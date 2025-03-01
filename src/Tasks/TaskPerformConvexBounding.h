/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE
   This software is licensed under the Eclipse Public License 2.0.
   Please see the README and LICENSE files for more information.
*/

#pragma once
#include "TaskBase.h"

#include "../MIPSolver/IMIPSolver.h"
#include "../Model/Problem.h"

#include "TaskCreateMIPProblem.h"

#include "TaskAddHyperplanes.h"
#include "TaskSelectHyperplanePointsObjectiveFunction.h"
#include "TaskSelectHyperplanePointsESH.h"
#include "TaskSelectHyperplanePointsECP.h"
#include "TaskUpdateInteriorPoint.h"

namespace SHOT
{

class TaskPerformConvexBounding : public TaskBase
{
public:
    TaskPerformConvexBounding(EnvironmentPtr envPtr, bool ignoreIdleIterations = false);
    ~TaskPerformConvexBounding() override;

    void run() override;
    std::string getType() override;

private:
    std::shared_ptr<TaskCreateMIPProblem> taskCreateMIPProblem;
    int lastNumberOfHyperplanesWithConvexSource = 0;
    int lastNumberOfHyperplanesWithNonconvexSource = 0;
    int idleIterations = 0;
    bool ignoreIdleIterations = false;
    int lastAddedHyperplane = 0;

    std::shared_ptr<TaskBase> taskSelectHPPts;
    std::shared_ptr<TaskSelectHyperplanePointsObjectiveFunction> taskSelectHPPtsByObjectiveRootsearch;
    std::shared_ptr<TaskUpdateInteriorPoint> taskUpdateInteriorPoint;
    std::shared_ptr<TaskAddHyperplanes> taskAddHyperplanes;

    MIPSolverPtr MIPSolver;
};
} // namespace SHOT