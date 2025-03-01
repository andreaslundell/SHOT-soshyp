/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE
   This software is licensed under the Eclipse Public License 2.0.
   Please see the README and LICENSE files for more information.
*/

#include "TaskPerformConvexBounding.h"

#include "../DualSolver.h"
#include "../Output.h"
#include "../Settings.h"
#include "../Timing.h"

#include "../MIPSolver/IMIPSolver.h"

#ifdef HAS_CPLEX
#include "../MIPSolver/MIPSolverCplex.h"
#include "../MIPSolver/MIPSolverCplexSingleTree.h"
#include "../MIPSolver/MIPSolverCplexSingleTreeLegacy.h"
#endif

#ifdef HAS_GUROBI
#include "../MIPSolver/MIPSolverGurobi.h"
#include "../MIPSolver/MIPSolverGurobiSingleTree.h"
#endif

#ifdef HAS_CBC
#include "../MIPSolver/MIPSolverCbc.h"
#endif

#include "../Results.h"
#include "../Tasks/TaskCreateMIPProblem.h"

#include "../PrimalSolver.h"

namespace SHOT
{

TaskPerformConvexBounding::TaskPerformConvexBounding(EnvironmentPtr envPtr, bool ignoreIdleIterations)
    : TaskBase(envPtr)
{
    env->timing->startTimer("ConvexBounding");
    this->ignoreIdleIterations = ignoreIdleIterations;

    if(env->reformulatedProblem->properties.numberOfNonlinearConstraints > 0)
    {
        if(static_cast<ES_HyperplaneCutStrategy>(env->settings->getSetting<int>("CutStrategy", "Dual"))
            == ES_HyperplaneCutStrategy::ESH)
        {
            taskUpdateInteriorPoint = std::make_shared<TaskUpdateInteriorPoint>(env);
            taskSelectHPPts = std::make_shared<TaskSelectHyperplanePointsESH>(env);
        }
        else
        {
            taskSelectHPPts = std::make_shared<TaskSelectHyperplanePointsECP>(env);
        }
    }

    if(env->reformulatedProblem->objectiveFunction->properties.classification
        > E_ObjectiveFunctionClassification::Quadratic)
    {
        taskSelectHPPtsByObjectiveRootsearch = std::make_shared<TaskSelectHyperplanePointsObjectiveFunction>(env);
    }

#ifdef HAS_CPLEX
    if(env->results->usedMIPSolver == ES_MIPSolver::Cplex)
    {
        MIPSolver = MIPSolverPtr(std::make_shared<MIPSolverCplex>(env));
    }
#endif

#ifdef HAS_GUROBI
    if(env->results->usedMIPSolver == ES_MIPSolver::Gurobi)
    {
        MIPSolver = MIPSolverPtr(std::make_shared<MIPSolverGurobi>(env));
    }
#endif

#ifdef HAS_CBC
    if(env->results->usedMIPSolver == ES_MIPSolver::Cbc)
    {
        MIPSolver = MIPSolverPtr(std::make_shared<MIPSolverCbc>(env));
    }
#endif

    assert(MIPSolver);

    if(!MIPSolver->initializeProblem())
        throw Exception("         Cannot initialize selected MIP solver.");

    taskCreateMIPProblem = std::make_shared<TaskCreateMIPProblem>(env, MIPSolver, env->reformulatedProblem);
    taskCreateMIPProblem->run();

    taskAddHyperplanes = std::make_shared<TaskAddHyperplanes>(env);

    env->timing->stopTimer("ConvexBounding");
}

TaskPerformConvexBounding::~TaskPerformConvexBounding() = default;

void TaskPerformConvexBounding::run()
{
    env->timing->startTimer("ConvexBounding");

    if(env->solutionStatistics.numberOfHyperplanesWithNonconvexSource == 0)
    {
        env->output->outputDebug(
            "        Convex bounding not performed since no hyperplanes with nonconvex source have been added.");
        return;
    }

    if(lastNumberOfHyperplanesWithConvexSource == env->solutionStatistics.numberOfHyperplanesWithConvexSource)
    {
        env->output->outputDebug(
            "        Convex bounding not performed since no new hyperplanes with convex source have been added.");
        return;
    }

    if(!ignoreIdleIterations
        && this->idleIterations < env->settings->getSetting<int>("ConvexBounding.IdleIterations", "Dual"))
    {
        env->output->outputDebug(
            fmt::format("        Convex bounding not performed since number of idle iterations has "
                        "not been met. Idle iterations: {} / {}",
                this->idleIterations, env->settings->getSetting<int>("ConvexBounding.IdleIterations", "Dual")));

        this->idleIterations++;
        return;
    }

    this->idleIterations = 0;

    if(ignoreIdleIterations)

        env->output->outputInfo("        Forced convex bounding started");
    else
        env->output->outputInfo("        Convex bounding started");

    int numberHyperplanesAdded = 0;

    for(int i = lastAddedHyperplane; i < env->dualSolver->generatedHyperplanes.size(); ++i)
    {
        if(env->dualSolver->generatedHyperplanes[i].isSourceConvex)
        {
            if(MIPSolver->createHyperplane((Hyperplane)env->dualSolver->generatedHyperplanes[i]))
                numberHyperplanesAdded++;
        }
    }

    int lastAddedHyperplane = env->dualSolver->generatedHyperplanes.size();

    double currDual = env->results->getGlobalDualBound();

    int iterationNumber = env->results->getCurrentIteration()->iterationNumber;

    if(env->settings->getSetting<bool>("Debug.Enable", "Output"))
    {
        auto filename = fmt::format("{}/convexbounding_problem{}.lp",
            env->settings->getSetting<std::string>("Debug.Path", "Output"), iterationNumber - 1);

        MIPSolver->writeProblemToFile(filename);
    }

    auto timeLim = env->settings->getSetting<double>("TimeLimit", "Termination") - env->timing->getElapsedTime("Total");
    MIPSolver->setTimeLimit(timeLim);

    if(MIPSolver->getDiscreteVariableStatus() && env->results->hasPrimalSolution())
    {
        auto primalSol = env->results->primalSolution;
        env->reformulatedProblem->augmentAuxiliaryVariableValues(primalSol);
        // MIPSolver->addMIPStart(primalSol);
    }

    MIPSolver->setSolutionLimit(2100000000);

    env->output->outputInfo(fmt::format("         Problem created. Number of hyperplanes added: {}/{}",
        numberHyperplanesAdded, env->dualSolver->generatedHyperplanes.size()));
    auto solutionStatus = MIPSolver->solveProblem();

    auto solutionPoints = MIPSolver->getAllVariableSolutions();
    double objectiveBound = MIPSolver->getDualObjectiveValue();

    env->solutionStatistics.numberOfExploredNodes += MIPSolver->getNumberOfExploredNodes();

    env->output->outputInfo(fmt::format(
        "         Problem solved with return code {} and objective bound {}. Number of solutions in solution pool: {}",
        (int)solutionStatus, objectiveBound, solutionPoints.size()));

    if(solutionPoints.size() > 0)
    {
        double objectiveValue = MIPSolver->getObjectiveValue();

        DualSolution sol = { solutionPoints.at(0).point, E_DualSolutionSource::ConvexBounding, objectiveBound,
            iterationNumber, false };

        env->dualSolver->addDualSolutionCandidate(sol);

        if(env->reformulatedProblem->antiEpigraphObjectiveVariable)
        {
            for(auto& SOL : solutionPoints)
                SOL.point.at(env->reformulatedProblem->antiEpigraphObjectiveVariable->index) = objectiveValue;
        }

        int hyperplanesBefore = env->solutionStatistics.numberOfHyperplanesWithConvexSource
            + env->solutionStatistics.numberOfHyperplanesWithNonconvexSource;

        if(env->reformulatedProblem->properties.numberOfNonlinearConstraints > 0)
        {
            if(static_cast<ES_HyperplaneCutStrategy>(env->settings->getSetting<int>("CutStrategy", "Dual"))
                == ES_HyperplaneCutStrategy::ESH)
            {
                taskUpdateInteriorPoint->run();
                static_cast<TaskSelectHyperplanePointsESH*>(taskSelectHPPts.get())->run(solutionPoints);
            }
            else
            {
                static_cast<TaskSelectHyperplanePointsECP*>(taskSelectHPPts.get())->run(solutionPoints);
            }

            taskAddHyperplanes->run();
        }

        if(env->reformulatedProblem->objectiveFunction->properties.classification
            > E_ObjectiveFunctionClassification::Quadratic)
        {
            taskSelectHPPtsByObjectiveRootsearch->run(solutionPoints);
            taskAddHyperplanes->run();
        }

        int hyperplanesAfter = env->solutionStatistics.numberOfHyperplanesWithConvexSource
            + env->solutionStatistics.numberOfHyperplanesWithNonconvexSource;

        if(hyperplanesAfter > hyperplanesBefore)
        {
            env->output->outputInfo(
                fmt::format("#        Added {} hyperplanes generated from convex bounding to the dual solver.",
                    hyperplanesAfter - hyperplanesBefore));
        }

        env->primalSolver->addPrimalSolutionCandidates(solutionPoints, E_PrimalSolutionSource::ConvexBounding);

        for(auto& SOL : solutionPoints)
            env->primalSolver->addFixedNLPCandidate(SOL.point, E_PrimalNLPSource::FirstSolutionNewDualBound,
                SOL.objectiveValue, SOL.iterFound, SOL.maxDeviation);
    }
    else
    {
        DualSolution sol = { {}, E_DualSolutionSource::ConvexBounding, objectiveBound, iterationNumber, false };
        env->dualSolver->addDualSolutionCandidate(sol);
    }

    // Update solution stats
    if(env->reformulatedProblem->properties.isDiscrete && solutionStatus == E_ProblemSolutionStatus::Optimal)
    {
        if(env->reformulatedProblem->properties.isMIQPProblem)
        {
            env->solutionStatistics.numberOfBoundingProblemsOptimalMIQP++;
        }
        else if(env->reformulatedProblem->properties.isMIQCQPProblem)
        {
            env->solutionStatistics.numberOfBoundingProblemsOptimalMIQCQP++;
        }
        else
        {
            env->solutionStatistics.numberOfBoundingProblemsOptimalMILP++;
        }
    }
    else if(!env->reformulatedProblem->properties.isDiscrete)
    {
        if(env->reformulatedProblem->properties.isMIQPProblem)
        {
            env->solutionStatistics.numberOfBoundingProblemsQP++;
        }
        else if(env->reformulatedProblem->properties.isMIQCQPProblem)
        {
            env->solutionStatistics.numberOfBoundingProblemsQCQP++;
        }
        else
        {
            env->solutionStatistics.numberOfBoundingProblemsLP++;
        }
    }
    else if(env->reformulatedProblem->properties.isDiscrete
        && (solutionStatus == E_ProblemSolutionStatus::SolutionLimit
            || solutionStatus == E_ProblemSolutionStatus::TimeLimit
            || solutionStatus == E_ProblemSolutionStatus::NodeLimit))
    {

        if(env->reformulatedProblem->properties.isMIQPProblem)
        {
            env->solutionStatistics.numberOfBoundingProblemsFeasibleMIQP++;
        }
        else if(env->reformulatedProblem->properties.isMIQCQPProblem)
        {
            env->solutionStatistics.numberOfBoundingProblemsFeasibleMIQCQP++;
        }
        else
        {
            env->solutionStatistics.numberOfBoundingProblemsFeasibleMILP++;
        }
    }

    if(currDual != env->results->getGlobalDualBound())
    {
        env->output->outputInfo(fmt::format("x       Convex bounding finished with new global dual bound {}. Old bound "
                                            "was {}. Absolute improvement: {}",
            objectiveBound, currDual, std::abs(currDual - env->results->getGlobalDualBound())));

        env->solutionStatistics.numberOfDualImprovementsAfterConvexBounding++;
    }
    else
    {
        env->output->outputInfo(
            fmt::format("        Convex bounding finished with dual bound {}. No improvement over old bound {}",
                objectiveBound, env->results->getGlobalDualBound()));
    }

    lastNumberOfHyperplanesWithConvexSource = env->solutionStatistics.numberOfHyperplanesWithConvexSource;
    lastNumberOfHyperplanesWithNonconvexSource = env->solutionStatistics.numberOfHyperplanesWithNonconvexSource;

    env->timing->stopTimer("ConvexBounding");
}

std::string TaskPerformConvexBounding::getType()
{
    std::string type = typeid(this).name();
    return (type);
}
} // namespace SHOT