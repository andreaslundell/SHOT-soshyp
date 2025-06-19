#include <iostream>
#include <string>
#include <fstream>

#include "../src/DualSolver.h"
#include "../src/Enums.h"
#include "../src/Environment.h"
#include "../src/Output.h"
#include "../src/Model/Problem.h"
#include "../src/Report.h"
#include "../src/Results.h"
#include "../src/Settings.h"
#include "../src/Solver.h"
#include "../src/Structs.h"
#include "../src/Utilities.h"

#include <julia.h>

using namespace SHOT;

int itersWithoutAddedHPs = 0;
int order;
bool outputQuiet = false;
VectorString variableNames;

// Callback function definition
void externalHyperplaneSelection(EnvironmentPtr env, std::any args)
{
    try
    {
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

        auto filename = fmt::format("{0}/lasserre_solpt_{1}.txt",
            env->settings->getSetting<std::string>("Debug.Path", "Output"), prevIter->iterationNumber);
        Utilities::saveVariablePointVectorToFile(solution, variableNames, filename);

        jl_value_t* solutionPath = jl_cstr_to_string(filename.c_str());
        jl_value_t* directory = jl_cstr_to_string("");

        // Prepare the arguments
        jl_value_t* argOrder = jl_box_int64(order); // order
        jl_value_t* argQuiet = jl_box_bool(outputQuiet); // quiet

        // Create an array of arguments
        jl_value_t* args[4] = { solutionPath, directory, argOrder, argQuiet };
        jl_value_t* juliaCallResult = jl_call(funcSosHyp, args, 4);

        if(jl_exception_occurred())
        {
            env->output->outputError(fmt::format(
                "        Julia exception when calling sos_hyp: {}", jl_typeof_str(jl_exception_occurred())));
            std::cout << jl_eval_string("sprint(showerror, ccall(:jl_exception_occurred, Any, ()))") << std::endl;
            return;
        }

        if(jl_is_tuple(juliaCallResult))
        {
            jl_value_t* juliaObj = jl_fieldref(juliaCallResult, 0); // Float64
            jl_value_t* juliaVarIndexes = jl_fieldref(juliaCallResult, 1); // Vector{Int64}
            jl_value_t* juliaTermCoeffs = jl_fieldref(juliaCallResult, 2); // Vector{Float64}

            // Extract objectiveValue
            double objectiveValue = jl_unbox_float64(juliaObj);
            env->output->outputDebug(fmt::format("        Objective value: {}", objectiveValue));

            // Convert variableIndexes to C++ vector<int64_t>
            /*jl_array_t* juliaArrayVarIndexes = (jl_array_t*)juliaVarIndexes;
            size_t numVarIndexes = jl_array_len(juliaArrayVarIndexes);

            int64_t* arrayVarIndexes = jl_array_data(juliaArrayVarIndexes, int64_t);

            std::vector<int64_t> variableIndexes(arrayVarIndexes, arrayVarIndexes + numVarIndexes);*/

            jl_array_t* outerArray = (jl_array_t*)juliaVarIndexes;

            // Get the number of inner arrays
            size_t numInnerArrays = jl_array_len(outerArray);

            // Create a vector to store the flattened values
            std::vector<int64_t> variableIndexes;

            // Iterate through each inner array
            for(size_t i = 0; i < numInnerArrays - 1; ++i)
            {
                // Access the inner array
                jl_value_t* innerArrayValue = jl_array_ptr_ref(outerArray, i);

                // Ensure the inner array is valid
                if(!jl_is_array(innerArrayValue))
                {
                    std::cerr << "Error: Expected an array at index " << i << "." << std::endl;
                    continue;
                }

                // Cast the inner array to jl_array_t
                jl_array_t* innerArray = (jl_array_t*)innerArrayValue;

                // Get the data and length of the inner array
                int64_t* innerArrayData = (int64_t*)jl_array_data(innerArray, int64_t);
                size_t innerArrayLength = jl_array_len(innerArray);

                // Append the values to the flattened vector
                variableIndexes.insert(variableIndexes.end(), innerArrayData, innerArrayData + innerArrayLength);
            }

            // Convert termCoefficients to C++ vector<double>
            jl_array_t* juliaArrayTermCoeffs = (jl_array_t*)juliaTermCoeffs;
            size_t numTermCoeffs = jl_array_len(juliaArrayTermCoeffs);
            double* arrayTermCoeffs = jl_array_data(juliaArrayTermCoeffs, double);

            std::vector<double> termCoefficients(arrayTermCoeffs, arrayTermCoeffs + numTermCoeffs - 1);
            double rhsValue = -arrayTermCoeffs[numTermCoeffs - 1];

            for(auto& coeff : termCoefficients)
            {
                coeff *= -1.0; // Negate the coefficients
            }

            /*std::cout << "        Variable indexes: ";
            for(auto v : variableIndexes)
                std::cout << v << " ";

            std::cout << "\n        Term coefficients: ";
            for(auto c : termCoefficients)
                std::cout << std::setprecision(15) << c << " ";

            std::cout << std::endl;

            std::cout << "        RHS value: " << std::setprecision(15) << rhsValue << std::endl;*/

            std::vector<int> variableIndexesInt;
            std::transform(variableIndexes.begin(), variableIndexes.end(), std::back_inserter(variableIndexesInt),
                [](int64_t value) { return static_cast<int>(value - 1); });

            auto hyperplane = std::make_shared<ExternalHyperplane>();
            hyperplane->source = E_HyperplaneSource::External;
            hyperplane->variableIndexes = variableIndexesInt;
            hyperplane->variableCoefficients = termCoefficients;
            hyperplane->rhsValue = -rhsValue;
            hyperplane->description = fmt::format("lh_{0}", prevIter->iterationNumber);
            hyperplane->isGlobal = true;

            env->dualSolver->addHyperplane(hyperplane);
        }
        else
        {
            env->output->outputError(fmt::format("        Unexpected return type from Julia."));
        }
    }
    catch(const std::bad_any_cast& e)
    {
    }
}

void initializeJulia(EnvironmentPtr env)
{
    jl_init();

    // Load the Julia file
    jl_eval_string("include(\"..//soshyp//main.jl\")");
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

    // Write the reformulated problem to a file
    auto filename
        = fmt::format("{0}/lassarre_problem.txt", env->settings->getSetting<std::string>("Debug.Path", "Output"));
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

int main(int argc, const char* argv[])
{
    // Check if the correct number of arguments is provided
    if(argc <= 3)
    {
        std::cerr << "Usage: " << argv[0] << " <problem_filename> <options_filename> <order=2,3,...> <quiet=true/false>"
                  << std::endl;
        return 1;
    }

    // Extract arguments
    std::string problemFilename = argv[1];
    std::string optionsFilename = argv[2];

    order = argv[3] ? std::stoi(argv[3]) : 2; // Default order is 2 if not provided
    outputQuiet = (argc > 4 && std::string(argv[4]) == "true");

    std::cout << " Lasserre order is set to: " << order << std::endl;

    // Create a Solver instance
    std::unique_ptr<Solver> solver = std::make_unique<Solver>();
    auto env = solver->getEnvironment();

    env->report->outputSolverHeader();

    // Load options from the options file
    solver->setOptionsFromFile(optionsFilename);

    // Load the problem file
    if(!solver->setProblem(problemFilename))
    {
        std::cerr << "Error: Unable to load problem file: " << problemFilename << std::endl;
        return 1;
    }

    env->report->outputProblemInstanceReport();
    env->report->outputOptionsReport();

    // Registers a callback that is activated every time a new primal solution is found
    // Register the callback function
    solver->registerCallback(
        E_EventType::ExternalHyperplaneSelection, [&env](std::any args) { externalHyperplaneSelection(env, args); });

    // Initialize the Julia environment
    std::cout << " \n Initializing Julia environment..." << std::endl;
    initializeJulia(env);

    // Solve the problem
    if(!solver->solveProblem())
    {
        std::cerr << "Error: Problem solving failed." << std::endl;
        return 1;
    }

    solver->finalizeSolution();
    env->report->outputSolutionReport();

    return 0;
}