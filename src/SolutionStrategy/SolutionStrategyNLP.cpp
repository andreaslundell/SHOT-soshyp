/**
        The Supporting Hyperplane Optimization Toolkit (SHOT).

        @author Andreas Lundell, Åbo Akademi University

        @section LICENSE
        This software is licensed under the Eclipse Public License 2.0.
        Please see the README and LICENSE files for more information.
*/

#include "SolutionStrategyNLP.h"

#include "../TaskHandler.h"

#include "../Tasks/TaskFindInteriorPoint.h"
#include "../Tasks/TaskBase.h"
#include "../Tasks/TaskSequential.h"
#include "../Tasks/TaskGoto.h"
#include "../Tasks/TaskConditional.h"

#include "../Tasks/TaskInitializeIteration.h"
#include "../Tasks/TaskTerminate.h"

#include "../Tasks/TaskInitializeDualSolver.h"
#include "../Tasks/TaskCreateDualProblem.h"

#include "../Tasks/TaskExecuteSolutionLimitStrategy.h"
#include "../Tasks/TaskExecuteRelaxationStrategy.h"

#include "../Tasks/TaskPrintIterationReport.h"

#include "../Tasks/TaskSolveIteration.h"
#include "../Tasks/TaskPresolve.h"

#include "../Tasks/TaskRepairInfeasibleDualProblem.h"

#include "../Tasks/TaskCheckAbsoluteGap.h"
#include "../Tasks/TaskCheckIterationError.h"
#include "../Tasks/TaskCheckIterationLimit.h"
#include "../Tasks/TaskCheckDualStagnation.h"
#include "../Tasks/TaskCheckPrimalStagnation.h"
#include "../Tasks/TaskCheckConstraintTolerance.h"
#include "../Tasks/TaskCheckRelativeGap.h"
#include "../Tasks/TaskCheckTimeLimit.h"
#include "../Tasks/TaskCheckUserTermination.h"

#include "../Tasks/TaskInitializeRootsearch.h"
#include "../Tasks/TaskSelectHyperplanePointsESH.h"
#include "../Tasks/TaskSelectHyperplanePointsECP.h"
#include "../Tasks/TaskAddHyperplanes.h"

#ifdef HAS_JULIA
#include "../Tasks/TaskAddHyperplanesLasserreHierarchy.h"
#endif

#include "../Tasks/TaskAddPrimalReductionCut.h"
#include "../Tasks/TaskCheckMaxNumberOfPrimalReductionCuts.h"

#include "../Tasks/TaskSelectPrimalCandidatesFromSolutionPool.h"
#include "../Tasks/TaskSelectPrimalCandidatesFromRootsearch.h"
#include "../Tasks/TaskSelectPrimalFixedNLPPointsFromSolutionPool.h"

#include "../Tasks/TaskUpdateInteriorPoint.h"

#include "../Tasks/TaskSelectHyperplanePointsObjectiveFunction.h"

#include "../Tasks/TaskAddIntegerCuts.h"

#include "../Output.h"
#include "../Model/Problem.h"
#include "../Model/ObjectiveFunction.h"
#include "../Settings.h"
#include "../Timing.h"

namespace SHOT
{

SolutionStrategyNLP::SolutionStrategyNLP(EnvironmentPtr envPtr)
{
    env = envPtr;

    env->timing->createTimer("InteriorPointSearch", "- interior point search");

    env->timing->createTimer("DualStrategy", "- dual strategy");
    env->timing->createTimer("DualProblemsRelaxed", "  - solving relaxed problems");
    env->timing->createTimer("DualProblemsDiscrete", "  - solving MIP problems");
    env->timing->createTimer("DualCutGenerationRootSearch", "  - root search for constraint cuts");
    env->timing->createTimer("DualObjectiveRootSearch", "  - root search for objective cut");

    env->timing->createTimer("PrimalStrategy", "- primal strategy");
    env->timing->createTimer("PrimalBoundStrategyRootSearch", "  - performing root searches");

    auto tFinalizeSolution = std::make_shared<TaskSequential>(env);

    auto tInitMIPSolver = std::make_shared<TaskInitializeDualSolver>(env, false);
    env->tasks->addTask(tInitMIPSolver, "InitMIPSolver");

    if(env->settings->getSetting<int>("CutStrategy", "Dual") == (int)ES_HyperplaneCutStrategy::ESH
        && env->reformulatedProblem->properties.numberOfNonlinearConstraints > 0)
    {
        auto tFindIntPoint = std::make_shared<TaskFindInteriorPoint>(env);
        env->tasks->addTask(tFindIntPoint, "FindIntPoint");
    }

    auto tCreateDualProblem = std::make_shared<TaskCreateDualProblem>(env);
    env->tasks->addTask(tCreateDualProblem, "CreateDualProblem");

    auto tInitializeRootsearch = std::make_shared<TaskInitializeRootsearch>(env);
    env->tasks->addTask(tInitializeRootsearch, "InitializeRootsearch");

    auto tInitializeIteration = std::make_shared<TaskInitializeIteration>(env);
    env->tasks->addTask(tInitializeIteration, "InitIter");

    auto tAddHPs = std::make_shared<TaskAddHyperplanes>(env);
    env->tasks->addTask(tAddHPs, "AddHPs");

    auto tAddHPsLasserreHierarchy = std::make_shared<TaskAddHyperplanesLasserreHierarchy>(env);
    env->tasks->addTask(tAddHPsLasserreHierarchy, "AddHPsLasserreHierarchy");

    if(static_cast<ES_MIPPresolveStrategy>(env->settings->getSetting<int>("MIP.Presolve.Frequency", "Dual"))
        != ES_MIPPresolveStrategy::Never)
    {
        auto tPresolve = std::make_shared<TaskPresolve>(env);
        env->tasks->addTask(tPresolve, "Presolve");
    }

    auto tSolveIteration = std::make_shared<TaskSolveIteration>(env);
    env->tasks->addTask(tSolveIteration, "SolveIter");

    auto tSelectPrimSolPool = std::make_shared<TaskSelectPrimalCandidatesFromSolutionPool>(env);
    env->tasks->addTask(tSelectPrimSolPool, "SelectPrimSolPool");
    std::dynamic_pointer_cast<TaskSequential>(tFinalizeSolution)->addTask(tSelectPrimSolPool);

    if(env->settings->getSetting<bool>("Rootsearch.Use", "Primal")
        && env->reformulatedProblem->properties.numberOfNonlinearConstraints > 0)
    {
        auto tSelectPrimRootsearch = std::make_shared<TaskSelectPrimalCandidatesFromRootsearch>(env);
        env->tasks->addTask(tSelectPrimRootsearch, "SelectPrimRootsearch");
        std::dynamic_pointer_cast<TaskSequential>(tFinalizeSolution)->addTask(tSelectPrimRootsearch);
    }

    auto tPrintIterReport = std::make_shared<TaskPrintIterationReport>(env);
    env->tasks->addTask(tPrintIterReport, "PrintIterReport");

    if(env->reformulatedProblem->properties.convexity != E_ProblemConvexity::Convex)
    {
        auto tRepairInfeasibility = std::make_shared<TaskRepairInfeasibleDualProblem>(env, "SolveIter", "CheckAbsGap");
        env->tasks->addTask(tRepairInfeasibility, "RepairInfeasibility");
    }

    auto tCheckAbsGap = std::make_shared<TaskCheckAbsoluteGap>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckAbsGap, "CheckAbsGap");

    auto tCheckRelGap = std::make_shared<TaskCheckRelativeGap>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckRelGap, "CheckRelGap");

    auto tCheckIterLim = std::make_shared<TaskCheckIterationLimit>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckIterLim, "CheckIterLim");

    auto tCheckTimeLim = std::make_shared<TaskCheckTimeLimit>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckTimeLim, "CheckTimeLim");

    auto tCheckUserTerm = std::make_shared<TaskCheckUserTermination>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckUserTerm, "CheckUserTermination");

    auto tCheckIterError = std::make_shared<TaskCheckIterationError>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckIterError, "CheckIterError");

    auto tCheckConstrTol = std::make_shared<TaskCheckConstraintTolerance>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckConstrTol, "CheckConstrTol");

    auto tCheckPrimalStag = std::make_shared<TaskCheckPrimalStagnation>(env, "AddObjectiveCut", "CheckDualStag");
    env->tasks->addTask(tCheckPrimalStag, "CheckPrimalStag");

    if(env->reformulatedProblem->properties.convexity != E_ProblemConvexity::Convex
        && env->settings->getSetting<bool>("ReductionCut.Use", "Dual"))
    {
        auto tAddObjectiveCut = std::make_shared<TaskAddPrimalReductionCut>(env, "CheckDualStag", "CheckDualStag");
        env->tasks->addTask(tAddObjectiveCut, "AddObjectiveCut");
    }

    auto tCheckDualStag = std::make_shared<TaskCheckDualStagnation>(env, "FinalizeSolution");
    env->tasks->addTask(tCheckDualStag, "CheckDualStag");

    env->tasks->addTask(tInitializeIteration, "InitIter2");

    if(env->reformulatedProblem->properties.numberOfNonlinearConstraints > 0)
    {
        if(static_cast<ES_HyperplaneCutStrategy>(env->settings->getSetting<int>("CutStrategy", "Dual"))
            == ES_HyperplaneCutStrategy::ESH)
        {
            auto tUpdateInteriorPoint = std::make_shared<TaskUpdateInteriorPoint>(env);
            env->tasks->addTask(tUpdateInteriorPoint, "UpdateInteriorPoint");

            auto tSelectHPPts = std::make_shared<TaskSelectHyperplanePointsESH>(env);
            env->tasks->addTask(tSelectHPPts, "SelectHPPts");
        }
        else
        {
            auto tSelectHPPts = std::make_shared<TaskSelectHyperplanePointsECP>(env);
            env->tasks->addTask(tSelectHPPts, "SelectHPPts");
        }
    }

    if(env->reformulatedProblem->objectiveFunction->properties.classification
        > E_ObjectiveFunctionClassification::Quadratic)
    {
        auto tSelectObjectiveHPPts = std::make_shared<TaskSelectHyperplanePointsObjectiveFunction>(env);
        env->tasks->addTask(tSelectObjectiveHPPts, "SelectObjectiveHPPts");
    }

    env->tasks->addTask(tAddHPs, "AddHPs");

    auto tGoto = std::make_shared<TaskGoto>(env, "SolveIter");
    env->tasks->addTask(tGoto, "Goto");

    env->tasks->addTask(tFinalizeSolution, "FinalizeSolution");

    if(env->reformulatedProblem->properties.convexity != E_ProblemConvexity::Convex
        && env->settings->getSetting<bool>("ReductionCut.Use", "Dual"))
    {
        auto tAddObjectiveCutFinal = std::make_shared<TaskAddPrimalReductionCut>(env, "InitIter2", "Terminate");
        std::dynamic_pointer_cast<TaskSequential>(tFinalizeSolution)->addTask(tAddObjectiveCutFinal);
    }

    auto tTerminate = std::make_shared<TaskTerminate>(env);
    env->tasks->addTask(tTerminate, "Terminate");
}

SolutionStrategyNLP::~SolutionStrategyNLP() = default;

bool SolutionStrategyNLP::solveProblem()
{
    TaskPtr nextTask;

    try
    {
        while(env->tasks->getNextTask(nextTask))
        {
#ifdef SIMPLE_OUTPUT_CHARS
            env->output->outputTrace("---- Started task:  " + nextTask->getType());
            nextTask->run();
            env->output->outputTrace("---- Finished task: " + nextTask->getType());
#else
            env->output->outputTrace("┌─── Started task:  " + nextTask->getType());
            nextTask->run();
            env->output->outputTrace("└─── Finished task: " + nextTask->getType());
#endif
        }
    }
    catch(Exception& e)
    {
        env->output->outputCritical(fmt::format(" Cannot solve problem:  {}", e.what()));
        return (false);
    }

    return (true);
}

void SolutionStrategyNLP::initializeStrategy() { }
} // namespace SHOT