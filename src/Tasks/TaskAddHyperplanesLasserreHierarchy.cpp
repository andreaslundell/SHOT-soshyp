/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE
   This software is licensed under the Eclipse Public License 2.0.
   Please see the README and LICENSE files for more information.
*/

#include "TaskAddHyperplanesLasserreHierarchy.h"

#include "../Model/Constraints.h"
#include "../Model/Problem.h"

#include "../DualSolver.h"
#include "../MIPSolver/IMIPSolver.h"
#include "../Output.h"
#include "../Results.h"
#include "../Settings.h"
#include "../Timing.h"

#include <julia.h>

namespace SHOT
{

TaskAddHyperplanesLasserreHierarchy::TaskAddHyperplanesLasserreHierarchy(EnvironmentPtr envPtr) : TaskBase(envPtr)
{
    env->timing->startTimer("DualStrategy");
    itersWithoutAddedHPs = 0;

    env->timing->stopTimer("DualStrategy");

    jl_init();

    // Load the Julia file
    jl_eval_string("include(\"LasserreHierarchyCuts.jl\")");
    jl_eval_string("using .MyFuncs");

    // Get a handle to the function
}

TaskAddHyperplanesLasserreHierarchy::~TaskAddHyperplanesLasserreHierarchy() { jl_atexit_hook(0); }

void TaskAddHyperplanesLasserreHierarchy::run()
{
    env->timing->startTimer("DualStrategy");

    int addedHyperplanes = 0;

    jl_module_t* my_mod = (jl_module_t*)jl_eval_string("MyFuncs");
    jl_function_t* func = jl_get_function(my_mod, "sos_hyp");

    if(func == nullptr)
    {
        printf("Function not found!\n");
        jl_atexit_hook(0);
        return;
    }
    else
    {
        printf("Function found!\n");
    }

    // Call the function with arguments
    jl_value_t* arg1 = jl_box_int64(3);
    jl_value_t* arg2 = jl_box_int64(4);
    jl_value_t* ret = jl_call2(func, arg1, arg2);

    if(jl_exception_occurred())
    {
        std::cerr << "Julia exception: " << jl_typeof_str(jl_exception_occurred()) << std::endl;
        std::cerr << jl_string_ptr(jl_eval_string("sprint(showerror, ccall(:jl_exception_occurred, Any, ()))"))
                  << std::endl;
        jl_atexit_hook(0);
        return;
    }

    if(jl_is_tuple(ret))
    {
        jl_value_t* v = jl_fieldref(ret, 0);
        jl_value_t* c = jl_fieldref(ret, 1);
        std::cout << "sos_hyp returned a tuple." << std::endl;
        std::cout << "v type: " << jl_typeof_str(v) << std::endl;
        std::cout << "c type: " << jl_typeof_str(c) << std::endl;

        // Cast top-level array
        jl_array_t* indexes = (jl_array_t*)v;
        jl_array_t* coefficients = (jl_array_t*)c;
        size_t numberRows = jl_array_len(indexes);

        for(size_t i = 0; i < numberRows; i++)
        {
            jl_value_t* rowIndexes = jl_arrayref(indexes, i); // Each row
            jl_array_t* arrayIndexes = (jl_array_t*)rowIndexes;

            jl_value_t* rowCoefficients = jl_arrayref(coefficients, i); // Each row
            jl_array_t* arrayCoefficients = (jl_array_t*)rowCoefficients;

            size_t nColumns = jl_array_len(arrayIndexes);
            for(size_t j = 0; j < nColumns; j++)
            {
                jl_value_t* cellIndexes = jl_arrayref(arrayIndexes, j); // Each cell
                jl_array_t* arrayIndexes = (jl_array_t*)cellIndexes;

                jl_value_t* cellCoefficients = jl_arrayref(arrayCoefficients, j); // Each cell

                size_t numberOfIndexes = jl_array_len(arrayIndexes);

                std::cout << "[" << i << "][" << j << "] = [";

                if(numberOfIndexes > 0)
                {
                    auto variableIndex = jl_unbox_int64(jl_arrayref(arrayIndexes, 0));
                    // jl_array_t* arrayCoefficients = (jl_array_t*)cellCoefficients;
                    auto variableCoefficient = jl_unbox_float64(cellCoefficients);
                    std::cout << variableCoefficient << "*x[" << variableIndex << "]";
                }
                else
                {
                    auto variableCoefficient = jl_unbox_float64(cellCoefficients);
                    std::cout << variableCoefficient;
                }

                std::cout << "]\n";

                Hyperplane hyperplane;
                // hyperplane.sourceConstraint = NCV.constraint;
                // hyperplane.sourceConstraintIndex = NCV.constraint->index;
                hyperplane.generatedPoint = solPoints.at(i).point;
                hyperplane.isSourceConvex = (NCV.constraint->properties.convexity <= E_Convexity::Convex);

                hyperplane.source = E_HyperplaneSource::External;

                env->dualSolver->addHyperplane(hyperplane);

                addedHyperplanes++;

                // env->output->outputDebug(
                //    fmt::format("         Added hyperplane for constraint {} to waiting list with deviation {}",
                //        NCV.constraint->name, NCV.error));
            }
        }
    }
    else
    {
        std::cerr << "Unexpected return type." << std::endl;
    }

    /*auto currIter = env->results->getCurrentIteration(); // The unsolved new iteration

    if(!currIter->isMIP() || !env->settings->getSetting<bool>("HyperplaneCuts.Delay", "Dual")
        || !currIter->MIPSolutionLimitUpdated || itersWithoutAddedHPs > 5)
    {
        int addedHyperplanes = 0;

        for(auto k = env->dualSolver->hyperplaneWaitingList.size(); k > 0; k--)
        {
            if(addedHyperplanes >= env->settings->getSetting<int>("HyperplaneCuts.MaxPerIteration", "Dual"))
                break;

            auto tmpItem = env->dualSolver->hyperplaneWaitingList.at(k - 1);

            bool cutAddedSuccessfully = false;

            if(tmpItem.source == E_HyperplaneSource::PrimalSolutionSearchInteriorObjective)
            {
                cutAddedSuccessfully = env->dualSolver->MIPSolver->createInteriorHyperplane(tmpItem);
            }
            else
            {
                cutAddedSuccessfully = env->dualSolver->MIPSolver->createHyperplane(tmpItem);
            }

            if(cutAddedSuccessfully)
            {
                env->dualSolver->addGeneratedHyperplane(tmpItem);
                addedHyperplanes++;
                this->itersWithoutAddedHPs = 0;

                env->output->outputDebug(
                    fmt::format("        Cut added successfully for constraint {}.", tmpItem.sourceConstraintIndex));
            }
            else
            {
                env->output->outputDebug(fmt::format(
                    "        Cut not added successfully for constraint {}.", tmpItem.sourceConstraintIndex));
            }
        }

        if(!env->settings->getSetting<bool>("TreeStrategy.Multi.Reinitialize", "Dual"))
        {
            env->dualSolver->hyperplaneWaitingList.clear();
        }
    }
    else
    {
        this->itersWithoutAddedHPs++;
    }*/

    env->timing->stopTimer("DualStrategy");
}

std::string TaskAddHyperplanesLasserreHierarchy::getType()
{
    std::string type = typeid(this).name();
    return (type);
}
} // namespace SHOT