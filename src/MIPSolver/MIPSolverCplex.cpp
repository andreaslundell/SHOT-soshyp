/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE 
   This software is licensed under the Eclipse Public License 2.0. 
   Please see the README and LICENSE files for more information.
*/

#include "MIPSolverCplex.h"

namespace SHOT
{

MIPSolverCplex::MIPSolverCplex()
{
    // Should not be called
}

MIPSolverCplex::MIPSolverCplex(EnvironmentPtr envPtr)
{
    env = envPtr;
    initializeProblem();
}

MIPSolverCplex::~MIPSolverCplex()
{
    cplexVarConvers.clear();
    cplexModel.end();
    cplexVars.end();
    cplexConstrs.end();
    cplexInstance.end();
    cplexEnv.end();
}

bool MIPSolverCplex::initializeProblem()
{
    discreteVariablesActivated = true;

    if (alreadyInitialized)
    {
        cplexVarConvers.clear();
        cplexModel.end();
        cplexVars.end();
        cplexConstrs.end();
        cplexInstance.end();
    }
    else
    {
        prevSolutionLimit = 1;
        alreadyInitialized = true;
    }

    try
    {
        cplexModel = IloModel(cplexEnv);

        cplexVars = IloNumVarArray(cplexEnv);
        cplexConstrs = IloRangeArray(cplexEnv);
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when initializing model", e.getMessage());
        return (false);
    }

    cachedSolutionHasChanged = true;
    isVariablesFixed = false;

    checkParameters();
    modelUpdated = false;

    return (true);
}

bool MIPSolverCplex::addVariable(std::string name, E_VariableType type, double lowerBound, double upperBound)
{
    try
    {
        switch (type)
        {
        case E_VariableType::Real:
        {
            auto cplexVar = IloNumVar(cplexEnv, lowerBound, upperBound, ILOFLOAT, name.c_str());
            cplexVars.add(cplexVar);
            cplexModel.add(cplexVar);
            break;
        }
        case E_VariableType::Integer:
        case E_VariableType::Binary:
        {
            isProblemDiscrete = true;
            auto cplexVar = IloNumVar(cplexEnv, lowerBound, upperBound, ILOINT, name.c_str());
            cplexVars.add(cplexVar);
            cplexModel.add(cplexVar);
            break;
        }
        case E_VariableType::Semicontinuous:
        {
            isProblemDiscrete = true;
            auto cplexVar = IloSemiContVar(cplexEnv, lowerBound, upperBound, ILOFLOAT, name.c_str());
            cplexVars.add(cplexVar);
            cplexModel.add(cplexVar);
            break;
        }
        default:
        {
            break;
        }
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when adding variable to model: ", e.getMessage());
        return (false);
    }

    variableTypes.push_back(type);
    variableNames.push_back(name);
    variableLowerBounds.push_back(lowerBound);
    variableUpperBounds.push_back(upperBound);
    numberOfVariables++;
    return (true);
}

bool MIPSolverCplex::initializeObjective()
{
    try
    {
        objExpression = IloExpr(cplexEnv);
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when initializing objective function: ", e.getMessage());
        return (false);
    }

    return (true);
}

bool MIPSolverCplex::addLinearTermToObjective(double coefficient, int variableIndex)
{
    try
    {
        objExpression += coefficient * cplexVars[variableIndex];
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when adding linear term to objective: ", e.getMessage());
        return (false);
    }

    return (true);
}

bool MIPSolverCplex::addQuadraticTermToObjective(double coefficient, int firstVariableIndex, int secondVariableIndex)
{
    try
    {
        objExpression += coefficient * cplexVars[firstVariableIndex] * cplexVars[secondVariableIndex];
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when adding quadratic term to objective: ", e.getMessage());
        return (false);
    }

    return (true);
}

bool MIPSolverCplex::finalizeObjective(bool isMinimize, double constant)
{
    try
    {
        if (constant != 0.0)
            objExpression += constant;

        if (isMinimize)
        {
            cplexModel.add(IloMinimize(cplexEnv, objExpression));
            isMinimizationProblem = true;
        }
        else
        {
            cplexModel.add(IloMaximize(cplexEnv, objExpression));
            isMinimizationProblem = false;
        }
    }
    catch (IloException &e)
    {
        objExpression.end();
        env->output->outputError("Cplex exception caught when adding objective function to model: ", e.getMessage());
        return (false);
    }

    objExpression.end();
    return (true);
}

bool MIPSolverCplex::initializeConstraint()
{
    try
    {
        constrExpression = IloExpr(cplexEnv);
    }
    catch (IloException &e)
    {
        objExpression.end();
        env->output->outputError("Cplex exception caught when initializing constraint: ", e.getMessage());
        return (false);
    }

    return (true);
}

bool MIPSolverCplex::addLinearTermToConstraint(double coefficient, int variableIndex)
{
    try
    {
        constrExpression += coefficient * cplexVars[variableIndex];
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when adding linear term to constraint: ", e.getMessage());
        return (false);
    }

    return (true);
}

bool MIPSolverCplex::addQuadraticTermToConstraint(double coefficient, int firstVariableIndex, int secondVariableIndex)
{
    try
    {
        constrExpression += coefficient * cplexVars[firstVariableIndex] * cplexVars[secondVariableIndex];
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when adding quadratic term to constraint: ", e.getMessage());
        return (false);
    }

    return (true);
}

bool MIPSolverCplex::finalizeConstraint(std::string name, double valueLHS, double valueRHS, double constant)
{
    try
    {
        if (constant != 0.0)
            constrExpression += constant;

        if (valueLHS <= valueRHS)
        {
            IloRange tmpRange = IloRange(cplexEnv, valueLHS, constrExpression, valueRHS, name.c_str());
            cplexConstrs.add(tmpRange);
            cplexModel.add(tmpRange);
        }
        else
        {
            IloRange tmpRange = IloRange(cplexEnv, valueRHS, constrExpression, valueLHS, name.c_str());
            cplexConstrs.add(tmpRange);
            cplexModel.add(tmpRange);
        }
    }
    catch (IloException &e)
    {
        constrExpression.end();
        env->output->outputError("Cplex exception caught when adding constraint to model: ", e.getMessage());
        return (false);
    }

    constrExpression.end();

    numberOfConstraints++;
    return (true);
}

bool MIPSolverCplex::finalizeProblem()
{
    try
    {
        if (env->settings->getBoolSetting("TreeStrategy.Multi.Reinitialize", "Dual"))
        {
            int setSolLimit;
            bool discreteVariablesActivated = getDiscreteVariableStatus();

            if (env->process->iterations.size() > 0)
            {
                setSolLimit = env->process->getCurrentIteration()->usedMIPSolutionLimit;
                discreteVariablesActivated = env->process->getCurrentIteration()->isMIP();
            }
            else
            {
                setSolLimit = env->settings->getIntSetting("MIP.SolutionLimit.Initial", "Dual");
            }

            cplexInstance = IloCplex(cplexModel);
            setSolutionLimit(setSolLimit);

            if (!discreteVariablesActivated)
            {
                activateDiscreteVariables(false);
            }
        }
        else
        {
            cplexInstance = IloCplex(cplexModel);
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex exception caught when finalizing model", e.getMessage());
        return (false);
    }

    return (true);
}

void MIPSolverCplex::initializeSolverSettings()
{
    try
    {
        // Disable Cplex output
        if (!env->settings->getBoolSetting("Console.DualSolver.Show", "Output"))
        {
            cplexInstance.setOut(cplexEnv.getNullStream());

            if (env->settings->getIntSetting("Console.LogLevel", "Output") <= static_cast<int>(ENUM_OUTPUT_LEVEL_summary))
            {
                cplexInstance.setWarning(cplexEnv.getNullStream());
            }
        }

        cplexInstance.setParam(IloCplex::Param::MIP::Tolerances::MIPGap, env->settings->getDoubleSetting("ObjectiveGap.Relative", "Termination") / 1.0);
        cplexInstance.setParam(IloCplex::Param::MIP::Tolerances::AbsMIPGap, env->settings->getDoubleSetting("ObjectiveGap.Absolute", "Termination") / 1.0);

        if (env->settings->getBoolSetting("TreeStrategy.Multi.Reinitialize", "Dual"))
        {
            if (env->process->iterations.size() == 0)
                cplexInstance.setParam(IloCplex::IntSolLim, env->settings->getIntSetting("MIP.SolutionLimit.Initial", "Dual"));
        }
        else
        {
            cplexInstance.setParam(IloCplex::IntSolLim, 21000000);
        }

        cplexInstance.setParam(IloCplex::SolnPoolIntensity, env->settings->getIntSetting("Cplex.SolnPoolIntensity", "Subsolver")); // Don't use 3 with heuristics
        cplexInstance.setParam(IloCplex::SolnPoolReplace, env->settings->getIntSetting("Cplex.SolnPoolReplace", "Subsolver"));
        cplexInstance.setParam(IloCplex::SolnPoolGap, env->settings->getDoubleSetting("Cplex.SolnPoolGap", "Subsolver"));
        cplexInstance.setParam(IloCplex::SolnPoolCapacity, env->settings->getIntSetting("MIP.SolutionPool.Capacity", "Dual"));

        cplexInstance.setParam(IloCplex::Probe, env->settings->getIntSetting("Cplex.Probe", "Subsolver"));
        cplexInstance.setParam(IloCplex::MIPEmphasis, env->settings->getIntSetting("Cplex.MIPEmphasis", "Subsolver"));

        cplexInstance.setParam(IloCplex::ParallelMode, env->settings->getIntSetting("Cplex.ParallelMode", "Subsolver"));
        cplexInstance.setParam(IloCplex::Threads, env->settings->getIntSetting("MIP.NumberOfThreads", "Dual"));

        cplexInstance.setParam(IloCplex::NumericalEmphasis, env->settings->getIntSetting("Cplex.NumericalEmphasis", "Subsolver"));
        cplexInstance.setParam(IloCplex::MemoryEmphasis, env->settings->getIntSetting("Cplex.MemoryEmphasis", "Subsolver"));

        // Options for using swap file
        cplexInstance.setParam(IloCplex::WorkDir, env->settings->getStringSetting("Cplex.WorkDir", "Subsolver").c_str());
        cplexInstance.setParam(IloCplex::WorkMem, env->settings->getDoubleSetting("Cplex.WorkMem", "Subsolver"));
        cplexInstance.setParam(IloCplex::NodeFileInd, env->settings->getIntSetting("Cplex.NodeFileInd", "Subsolver"));
    }
    catch (IloException &e)
    {
        env->output->outputError("Cplex error when initializing parameters for linear solver", e.getMessage());
    }
}

int MIPSolverCplex::addLinearConstraint(const std::vector<PairIndexValue> &elements, double constant, bool isGreaterThan)
{
    try
    {
        IloExpr expr(cplexEnv);

        for (int i = 0; i < elements.size(); i++)
        {
            expr += elements.at(i).value * cplexVars[elements.at(i).index];
        }

        if (isGreaterThan)
        {
            IloRange tmpRange(cplexEnv, -constant, expr);
            cplexConstrs.add(tmpRange);
            cplexModel.add(tmpRange);
        }
        else
        {
            IloRange tmpRange(cplexEnv, -IloInfinity, expr, -constant);
            cplexConstrs.add(tmpRange);
            cplexModel.add(tmpRange);
        }

        modelUpdated = true;

        expr.end();
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when adding linear constraint", e.getMessage());

        return (-1);
    }

    return (cplexInstance.getNrows() - 1);
}

void MIPSolverCplex::activateDiscreteVariables(bool activate)
{
    try
    {
        for (int i = 0; i < cplexVarConvers.size(); i++)
        {
            cplexVarConvers.at(i).end();
        }

        cplexVarConvers.clear();

        if (activate)
        {
            for (int i = 0; i < numberOfVariables; i++)
            {
                if (variableTypes.at(i) == E_VariableType::Integer)
                {
                    auto tmpVar = cplexVars[i];
                    auto tmpConv = IloConversion(cplexEnv, tmpVar, ILOINT);
                    cplexModel.add(tmpConv);
                    cplexVarConvers.push_back(tmpConv);
                }
                else if (variableTypes.at(i) == E_VariableType::Binary)
                {
                    auto tmpVar = cplexVars[i];
                    auto tmpConv = IloConversion(cplexEnv, tmpVar, ILOBOOL);
                    cplexModel.add(tmpConv);
                    cplexVarConvers.push_back(tmpConv);
                }
            }

            discreteVariablesActivated = true;
        }
        else
        {
            for (int i = 0; i < numberOfVariables; i++)
            {
                if (variableTypes.at(i) == E_VariableType::Integer || variableTypes.at(i) == E_VariableType::Binary)
                {
                    auto tmpVar = cplexVars[i];
                    auto tmpConv = IloConversion(cplexEnv, tmpVar, ILOFLOAT);
                    cplexModel.add(tmpConv);
                    cplexVarConvers.push_back(tmpConv);
                }
            }

            discreteVariablesActivated = false;
        }
    }
    catch (IloException &e)
    {
        if (activate)
            env->output->outputError("Error when activating discrete variables",
                                     e.getMessage());
    }
}

E_ProblemSolutionStatus MIPSolverCplex::getSolutionStatus()
{
    E_ProblemSolutionStatus MIPSolutionStatus;

    try
    {
        auto status = cplexInstance.getCplexStatus();

        if (status == IloCplex::CplexStatus::Optimal || status == IloCplex::CplexStatus::OptimalTol)
        {
            auto statusInstance = cplexInstance.getStatus();

            if (statusInstance == IloAlgorithm::Status::Optimal)
            {
                MIPSolutionStatus = E_ProblemSolutionStatus::Optimal;
            }
            else
            {
                MIPSolutionStatus = E_ProblemSolutionStatus::SolutionLimit;
            }
        }
        else if (status == IloCplex::CplexStatus::Infeasible)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::Infeasible;
        }
        else if (status == IloCplex::CplexStatus::InfOrUnbd)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::Infeasible;
        }
        else if (status == IloCplex::CplexStatus::Unbounded)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::Unbounded;
        }
        else if (status == IloCplex::CplexStatus::NodeLimFeas)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::NodeLimit;
        }
        else if (status == IloCplex::CplexStatus::NumBest)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::Feasible;
        }
        else if (status == IloCplex::CplexStatus::AbortTimeLim || status == IloCplex::CplexStatus::AbortDetTimeLim)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::TimeLimit;
        }
        else if (status == IloCplex::CplexStatus::SolLim)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::SolutionLimit;
        }
        else if (status == IloCplex::CplexStatus::AbortUser)
        {
            MIPSolutionStatus = E_ProblemSolutionStatus::Abort;
        }
        else
        {
            env->output->outputError("MIP solver return status " + std::to_string(status));
            MIPSolutionStatus = E_ProblemSolutionStatus::Error;
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when obtaining solution status", e.getMessage());
        MIPSolutionStatus = E_ProblemSolutionStatus::Error;
    }

    return (MIPSolutionStatus);
}

E_ProblemSolutionStatus MIPSolverCplex::solveProblem()
{
    E_ProblemSolutionStatus MIPSolutionStatus;
    cachedSolutionHasChanged = true;

    try
    {
        if (modelUpdated)
        {
            cplexInstance.extract(cplexModel);

            modelUpdated = false;
        }

        cplexInstance.solve();

        MIPSolutionStatus = getSolutionStatus();
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when solving MIP/LP problem", e.getMessage());
        MIPSolutionStatus = E_ProblemSolutionStatus::Error;
    }

    return (MIPSolutionStatus);
}

int MIPSolverCplex::increaseSolutionLimit(int increment)
{
    int sollim;

    try
    {
        cplexInstance.setParam(IloCplex::IntSolLim, cplexInstance.getParam(cplexInstance.IntSolLim) + increment);
        sollim = cplexInstance.getParam(cplexInstance.IntSolLim);
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when increasing solution limit", e.getMessage());
    }

    return (sollim);
}

void MIPSolverCplex::setSolutionLimit(long limit)
{
    try
    {
        cplexInstance.setParam(IloCplex::IntSolLim, limit);
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when setting solution limit", e.getMessage());
    }
}

int MIPSolverCplex::getSolutionLimit()
{
    int solLim = 0;

    try
    {
        solLim = cplexInstance.getParam(cplexInstance.IntSolLim);
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when obtaining solution limit", e.getMessage());
    }

    return (solLim);
}

VectorDouble MIPSolverCplex::getVariableSolution(int solIdx)
{
    bool isMIP = getDiscreteVariableStatus() && isProblemDiscrete;
    int numVar = cplexVars.getSize();
    VectorDouble solution(numVar);

    IloNumArray tmpSolsCplex(cplexEnv);

    try
    {
        if (isMIP)
        {
            cplexInstance.getValues(cplexVars, tmpSolsCplex, solIdx);
        }
        else
        {
            cplexInstance.getValues(cplexVars, tmpSolsCplex);
        }

        for (int i = 0; i < numVar; i++)
        {
            solution.at(i) = tmpSolsCplex[i];
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when reading solution with index " + std::to_string(solIdx),
                                 e.getMessage());
    }

    tmpSolsCplex.end();
    return (solution);
}

int MIPSolverCplex::getNumberOfSolutions()
{
    int numSols = 0;
    bool isMIP = getDiscreteVariableStatus();

    try
    {
        if (isProblemDiscrete && isMIP)
        {
            numSols = cplexInstance.getSolnPoolNsolns();
        }
        else
        {
            numSols = 1;
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when obtaining number of solutions", e.getMessage());
    }

    return (numSols);
}

double MIPSolverCplex::getObjectiveValue(int solIdx)
{
    bool isMIP = getDiscreteVariableStatus() && isProblemDiscrete;

    double objVal = NAN;

    if (!isMIP && solIdx > 0) // LP problems only have one solution!
    {
        env->output->outputError(
            "Cannot obtain solution with index " + std::to_string(solIdx) + " since the problem is LP/QP!");
        return (objVal);
    }

    try
    {
        if (isMIP)
        {
            objVal = cplexInstance.getObjValue(solIdx);
        }
        else
        {
            objVal = cplexInstance.getObjValue();
        }
    }
    catch (IloException &e)
    {
        env->output->outputError(
            "Error when obtaining objective value for solution index " + std::to_string(solIdx), e.getMessage());
    }

    return (objVal);
}

void MIPSolverCplex::setTimeLimit(double seconds)
{
    try
    {
        if (seconds > 0)
        {
            cplexInstance.setParam(IloCplex::TiLim, seconds);
        }
        else
        {
            cplexInstance.setParam(IloCplex::TiLim, 0.01);
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when setting time limit", e.getMessage());
    }
}

void MIPSolverCplex::setCutOff(double cutOff)
{
    double cutOffTol = env->settings->getDoubleSetting("MIP.CutOffTolerance", "Dual");

    try
    {
        if (isMinimizationProblem)
        {
            cplexInstance.setParam(IloCplex::CutUp, cutOff + cutOffTol);

            env->output->outputInfo(
                "     Setting cutoff value to " + std::to_string(cutOff + cutOffTol) + " for minimization.");
        }
        else
        {
            cplexInstance.setParam(IloCplex::CutLo, cutOff - cutOffTol);
            env->output->outputInfo(
                "     Setting cutoff value to " + std::to_string(cutOff - cutOffTol) + " for maximization.");
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when setting cut off value", e.getMessage());
    }
}

void MIPSolverCplex::addMIPStart(VectorDouble point)
{
    IloNumArray startVal(cplexEnv);

    int numVar = cplexVars.getSize();

    for (int i = 0; i < point.size(); i++)
    {
        startVal.add(point.at(i));
    }

    if (this->hasAuxilliaryObjectiveVariable() && numVar == point.size() + 1)
    {
        startVal.add(env->process->getPrimalBound());
    }

    try
    {
        cplexInstance.addMIPStart(cplexVars, startVal);
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when adding MIP starting point", e.getMessage());
    }

    startVal.end();

    env->output->outputInfo("     Added MIP starting point.");
}

void MIPSolverCplex::deleteMIPStarts()
{
    int numStarts = cplexInstance.getNMIPStarts();

    if (numStarts > 0)
    {
        try
        {
            cplexInstance.deleteMIPStarts(0, numStarts);
        }
        catch (IloException &e)
        {
            env->output->outputError("Error when deleting MIP starting points", e.getMessage());
        }

        env->output->outputDebug("    Deleted " + std::to_string(numStarts) + " MIP starting points.");
    }
}

void MIPSolverCplex::writeProblemToFile(std::string filename)
{
    try
    {
        if (modelUpdated)
        {
            //Extract the model if we have updated the constraints
            cplexInstance.extract(cplexModel);
            modelUpdated = false;
        }

        cplexInstance.exportModel(filename.c_str());
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when saving model to file", e.getMessage());
    }
}

void MIPSolverCplex::fixVariable(int varIndex, double value)
{
    updateVariableBound(varIndex, value, value);
}

void MIPSolverCplex::updateVariableBound(int varIndex, double lowerBound, double upperBound)
{
    try
    {
        cplexVars[varIndex].setBounds(lowerBound, upperBound);
        modelUpdated = true;
    }
    catch (IloException &e)
    {
        env->output->outputError(
            "Error when updating variable bounds for variable index" + std::to_string(varIndex), e.getMessage());
    }
}

void MIPSolverCplex::updateVariableLowerBound(int varIndex, double lowerBound)
{
    try
    {
        cplexVars[varIndex].setLB(lowerBound);
        modelUpdated = true;
    }
    catch (IloException &e)
    {
        env->output->outputError(
            "Error when updating variable bounds for variable index" + std::to_string(varIndex), e.getMessage());
    }
}

void MIPSolverCplex::updateVariableUpperBound(int varIndex, double upperBound)
{
    try
    {
        cplexVars[varIndex].setUB(upperBound);
        modelUpdated = true;
    }
    catch (IloException &e)
    {
        env->output->outputError(
            "Error when updating variable bounds for variable index" + std::to_string(varIndex), e.getMessage());
    }
}

PairDouble MIPSolverCplex::getCurrentVariableBounds(int varIndex)
{
    PairDouble tmpBounds;

    try
    {
        tmpBounds.first = cplexVars[varIndex].getLB();
        tmpBounds.second = cplexVars[varIndex].getUB();
    }
    catch (IloException &e)
    {
        env->output->outputError(
            "Error when obtaining variable bounds for variable index" + std::to_string(varIndex), e.getMessage());
    }
    return (tmpBounds);
}

bool MIPSolverCplex::supportsQuadraticObjective()
{
    return (true);
}
bool MIPSolverCplex::supportsQuadraticConstraints()
{
    return (true);
}

double MIPSolverCplex::getDualObjectiveValue()
{
    double objVal = NAN;

    bool isMIP = getDiscreteVariableStatus() && isProblemDiscrete;

    try
    {
        if (isMIP)
        {
            objVal = cplexInstance.getBestObjValue();
        }
        else
        {
            objVal = cplexInstance.getObjValue();
        }
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when obtaining dual objective value", e.getMessage());
    }

    return (objVal);
}

std::pair<VectorDouble, VectorDouble> MIPSolverCplex::presolveAndGetNewBounds()
{
    IloNumArray redubs(cplexEnv, numberOfVariables);
    IloNumArray redlbs(cplexEnv, numberOfVariables);

    IloBoolArray redund(cplexEnv);

    try
    {
        bool isUpdated = false;

        cplexInstance.basicPresolve(cplexVars, redlbs, redubs, cplexConstrs, redund);

        VectorDouble newLBs;
        VectorDouble newUBs;

        newLBs.reserve(numberOfVariables);
        newUBs.reserve(numberOfVariables);

        for (int i = 0; i < numberOfVariables; i++)
        {
            newLBs.push_back(redlbs[i]);
            newUBs.push_back(redubs[i]);
        }

        if (env->settings->getBoolSetting("MIP.Presolve.RemoveRedundantConstraints", "Dual"))
        {
            int numconstr = 0;

            for (int j = 0; j < cplexConstrs.getSize(); j++)
            {
                if (redund[j] == true)
                {
                    cplexModel.remove(cplexConstrs[j]);
                    cplexConstrs[j].asConstraint().removeFromAll();

                    numconstr++;
                    isUpdated = true;
                }
            }

            if (isUpdated)
            {
                cplexInstance.extract(cplexModel);
                env->output->outputInfo(
                    "     Removed " + std::to_string(numconstr) + " redundant constraints from MIP model.");
                env->solutionStatistics.numberOfConstraintsRemovedInPresolve = numconstr;
            }
        }

        redlbs.end();
        redubs.end();
        redund.end();

        return (std::make_pair(newLBs, newUBs));
    }
    catch (IloException &e)
    {
        redlbs.end();
        redubs.end();
        redund.end();

        env->output->outputError("Error during presolve", e.getMessage());

        return (std::make_pair(variableLowerBounds, variableUpperBounds));
    }
}

void MIPSolverCplex::writePresolvedToFile(std::string filename)
{
    try
    {
        //Not implemented
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when saving presolved model to file", e.getMessage());
    }
}

void MIPSolverCplex::checkParameters()
{
}

void MIPSolverCplex::createHyperplane(Hyperplane hyperplane,
                                      std::function<IloConstraint(IloRange)> addConstraintFunction)
{
    auto currIter = env->process->getCurrentIteration(); // The unsolved new iteration

    auto optional = createHyperplaneTerms(hyperplane);

    if (!optional)
    {
        return;
    }

    auto tmpPair = optional.get();

    //auto tmpPair = createHyperplaneTerms(hyperplane);
    bool hyperplaneIsOk = true;

    for (auto E : tmpPair.first)
    {
        if (E.value != E.value) //Check for NaN
        {
            env->output->outputWarning("     Warning: hyperplane not generated, NaN found in linear terms!");
            hyperplaneIsOk = false;
            break;
        }
    }

    if (hyperplaneIsOk)
    {
        GeneratedHyperplane genHyperplane;

        IloExpr expr(cplexEnv);

        for (int i = 0; i < tmpPair.first.size(); i++)
        {
            expr += tmpPair.first.at(i).value * cplexVars[tmpPair.first.at(i).index];
        }

        IloRange tmpRange(cplexEnv, -IloInfinity, expr, -tmpPair.second);

        auto addedConstr = addConstraintFunction(tmpRange);

        int constrIndex = 0;

        genHyperplane.generatedConstraintIndex = constrIndex;
        genHyperplane.sourceConstraintIndex = hyperplane.sourceConstraintIndex;
        genHyperplane.generatedPoint = hyperplane.generatedPoint;
        genHyperplane.source = hyperplane.source;
        genHyperplane.generatedIter = currIter->iterationNumber;
        genHyperplane.isLazy = false;
        genHyperplane.isRemoved = false;

        generatedHyperplanes.push_back(genHyperplane);

        currIter->numHyperplanesAdded++;
        currIter->totNumHyperplanes++;
        expr.end();
    }
}

void MIPSolverCplex::createIntegerCut(VectorInteger binaryIndexes,
                                      std::function<IloConstraint(IloRange)> addConstraintFunction)
{
    IloExpr expr(cplexEnv);

    for (int i = 0; i < binaryIndexes.size(); i++)
    {
        expr += 1.0 * cplexVars[binaryIndexes.at(i)];
    }

    IloRange tmpRange(cplexEnv, -IloInfinity, expr, binaryIndexes.size() - 1.0);

    auto addedConstr = addConstraintFunction(tmpRange);
    env->solutionStatistics.numberOfIntegerCuts++;

    expr.end();
}

int MIPSolverCplex::getNumberOfExploredNodes()
{
    try
    {
        return (cplexInstance.getNnodes());
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when getting number of explored nodes", e.getMessage());
        return 0;
    }
}

int MIPSolverCplex::getNumberOfOpenNodes()
{
    try
    {
        int nodesLeft = cplexInstance.getNnodesLeft();

        env->solutionStatistics.numberOfOpenNodes = nodesLeft;

        return (cplexInstance.getNnodesLeft());
    }
    catch (IloException &e)
    {
        env->output->outputError("Error when getting number of open nodes", e.getMessage());
        return 0;
    }
}
} // namespace SHOT