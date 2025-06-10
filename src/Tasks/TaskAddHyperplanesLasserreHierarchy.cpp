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
    jl_eval_string("include(\"soshyp//main.jl\")");
    env->output->outputDebug("        Loading Julia module.");
    jl_eval_string("using .soshyp");
    env->output->outputDebug("        Julia module loaded.");

    if(jl_exception_occurred())
    {
        env->output->outputError(
            fmt::format("        Julia exception when preparing problem: {}", jl_typeof_str(jl_exception_occurred())));
        std::cout << jl_eval_string("sprint(showerror, ccall(:jl_exception_occurred, Any, ()))") << std::endl;
        return;
    }

    // Get a handle to the function
    jl_module_t* module = (jl_module_t*)jl_eval_string("soshyp");

    if(jl_exception_occurred())
    {
        env->output->outputError(
            fmt::format("        Julia exception when loading module: {}", jl_typeof_str(jl_exception_occurred())));
        std::cout << jl_eval_string("sprint(showerror, ccall(:jl_exception_occurred, Any, ()))") << std::endl;
        return;
    }

    jl_function_t* funcPrepareProblem = jl_get_function(module, "prepare_problem");

    if(funcPrepareProblem == nullptr)
    {
        env->output->outputError("        Function prepare_problem not found!");
        return;
    }

    std::string filename = "/tmp/lassarre_problem.txt";
    std::stringstream problem;
    problem << env->reformulatedProblem;
    Utilities::writeStringToFile(filename, problem.str());

    jl_value_t* problemPath = jl_cstr_to_string(filename.c_str());
    jl_value_t* directory = jl_cstr_to_string("");
    jl_value_t* prepareProblemStatus = jl_call2(funcPrepareProblem, problemPath, directory);

    if(jl_exception_occurred())
    {
        env->output->outputError(
            fmt::format("        Julia exception when preparing problem: {}", jl_typeof_str(jl_exception_occurred())));
        std::cout << jl_eval_string("sprint(showerror, ccall(:jl_exception_occurred, Any, ()))") << std::endl;
        return;
    }

    for(auto& V : env->reformulatedProblem->allVariables)
        variableNames.push_back(V->name);
}

TaskAddHyperplanesLasserreHierarchy::~TaskAddHyperplanesLasserreHierarchy() { jl_atexit_hook(0); }

void TaskAddHyperplanesLasserreHierarchy::run()
{
    env->timing->startTimer("DualStrategy");

    if(env->results->getNumberOfIterations() == 1)
        return;

    auto prevIter = env->results->getPreviousIteration();

    if(prevIter->solutionPoints.size() == 0)
        return;

    jl_module_t* module = (jl_module_t*)jl_eval_string("soshyp");
    jl_function_t* funcSosHyp = jl_get_function(module, "sos_hyp");

    if(funcSosHyp == nullptr)
    {
        env->output->outputDebug("        Function sos_hyp not found!");
        return;
    }

    if(jl_exception_occurred())
    {
        env->output->outputError(fmt::format(
            "        Julia exception when defining sos_hyp function: {}", jl_typeof_str(jl_exception_occurred())));
        std::cout << jl_eval_string("sprint(showerror, ccall(:jl_exception_occurred, Any, ()))") << std::endl;
        return;
    }

    auto solution = prevIter->solutionPoints.at(0).point;
    // Utilities::displayVector(solution);

    auto filename = fmt::format("/tmp/solpt_{0}.txt", prevIter->iterationNumber);
    Utilities::saveVariablePointVectorToFile(solution, variableNames, filename);

    jl_value_t* solutionPath = jl_cstr_to_string(filename.c_str());
    jl_value_t* directory = jl_cstr_to_string("");
    jl_value_t* juliaCallResult = jl_call2(funcSosHyp, solutionPath, directory);

    if(jl_is_tuple(juliaCallResult))
    {
        jl_value_t* juliaObj = jl_fieldref(juliaCallResult, 0); // Float64
        jl_value_t* juliaVarIndexes = jl_fieldref(juliaCallResult, 1); // Vector{Int64}
        jl_value_t* juliaTermCoeffs = jl_fieldref(juliaCallResult, 2); // Vector{Float64}

        // Extract objectiveValue
        double objectiveValue = jl_unbox_float64(juliaObj);
        env->output->outputDebug(fmt::format("        Objective value: {}", objectiveValue));

        // Convert variableIndexes to C++ vector<int64_t>
        jl_array_t* juliaArrayVarIndexes = (jl_array_t*)juliaVarIndexes;
        size_t numVarIndexes = jl_array_len(juliaArrayVarIndexes);
        int64_t* arrayVarIndexes = jl_array_data(juliaArrayVarIndexes, int64_t);

        std::vector<int64_t> variableIndexes(arrayVarIndexes, arrayVarIndexes + numVarIndexes);

        // Convert termCoefficients to C++ vector<double>
        jl_array_t* juliaArrayTermCoeffs = (jl_array_t*)juliaTermCoeffs;
        size_t numTermCoeffs = jl_array_len(juliaArrayTermCoeffs);
        double* arrayTermCoeffs = jl_array_data(juliaArrayTermCoeffs, double);

        std::vector<double> termCoefficients(arrayTermCoeffs, arrayTermCoeffs + numTermCoeffs);

        /*std::cout << "Variable indexes: ";
        for(auto v : variableIndexes)
            std::cout << v << " ";

        std::cout << "\nTerm coefficients: ";
        for(auto c : termCoefficients)
            std::cout << std::setprecision(15) << c << " ";

        std::cout << std::endl;*/

        std::map<int, double> elements;

        for(size_t i = 0; i < variableIndexes.size(); ++i)
            elements[variableIndexes[i] - 1] = -termCoefficients[i]; // -1 to match C++ indexing

        // env->dualSolver->MIPSolver->addLinearConstraint(
        //     elements, -termCoefficients.back(), fmt::format("lh_{0}", prevIter->iterationNumber), false, false);

        std::vector<int> variableIndexesInt;
        std::transform(variableIndexes.begin(), variableIndexes.end(), std::back_inserter(variableIndexesInt),
            [](int64_t value) { return static_cast<int>(value - 1); });

        auto hyperplane = std::make_shared<ExternalHyperplane>();
        hyperplane->source = E_HyperplaneSource::External;
        hyperplane->variableIndexes = variableIndexesInt;
        hyperplane->variableCoefficients = termCoefficients;
        hyperplane->rhsValue = -termCoefficients.back();
        hyperplane->description = fmt::format("lh_{0}", prevIter->iterationNumber);

        env->dualSolver->addHyperplane(hyperplane);

        env->timing->stopTimer("DualStrategy");
    }
    else
    {
        env->output->outputError(fmt::format("        Unexpected return type from Julia."));
    }
}

std::string TaskAddHyperplanesLasserreHierarchy::getType()
{
    std::string type = typeid(this).name();
    return (type);
}
} // namespace SHOT