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
#include "../src/TaskHandler.h"
#include "../src/Utilities.h"

#include <julia.h>

using namespace SHOT;

int itersWithoutAddedHPs = 0;
int order = 2;
bool outputQuiet = false;
std::string sparsity = "all";
VectorString variableNames;
double lastObjValue = SHOT_DBL_MAX;

void printJuliaError(EnvironmentPtr env)
{
    if(!jl_exception_occurred())
        return;

    jl_value_t* exception = jl_exception_occurred();

    // Get the exception type
    jl_value_t* exception_type = jl_typeof(exception);
    const char* type_name = jl_typename_str(exception_type);

    // Get the exception message
    jl_value_t* msg = jl_get_field(exception, "msg");
    const char* error_msg = "";
    if(msg && jl_is_string(msg))
    {
        error_msg = jl_string_ptr(msg);
    }

    // Print detailed error information
    env->output->outputError(fmt::format("Julia Exception Type: {}", type_name));
    env->output->outputError(fmt::format("Julia Exception Message: {}", error_msg));

    // Clear the exception
    jl_exception_clear();
}

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
            env->output->outputError(fmt::format("        Julia exception when defining sos_hyp function"));
            printJuliaError(env);
            return;
        }

        auto solution = prevIter->solutionPoints.at(0).point;
        // Utilities::displayVector(solution);

        auto filename = fmt::format("{0}/lasserre_solpt_{1}.txt",
            env->settings->getSetting<std::string>("Debug.Path", "Output"), prevIter->iterationNumber);
        Utilities::saveVariablePointVectorToFile(solution, variableNames, filename);

        // Prepare the arguments
        jl_value_t* solutionPath = jl_cstr_to_string(filename.c_str());
        jl_value_t* directory = jl_cstr_to_string("");
        jl_value_t* argOrder = jl_box_int64(order); // order
        jl_value_t* argQuiet = jl_box_bool(outputQuiet); // quiet
        jl_value_t* argSparse = jl_cstr_to_string(sparsity.c_str()); // sparsity

        // Create an array of arguments
        jl_value_t* args[5] = { solutionPath, directory, argOrder, argQuiet, argSparse };
        jl_value_t* juliaCallResult = jl_call(funcSosHyp, args, 5);

        if(jl_exception_occurred())
        {
            env->output->outputError(fmt::format(
                "        Julia exception when calling sos_hyp: {}", jl_typeof_str(jl_exception_occurred())));
            printJuliaError(env);
            exit(1);
        }

        if(jl_is_tuple(juliaCallResult))
        {
            jl_value_t* juliaObj = jl_fieldref(juliaCallResult, 0); // Float64
            jl_value_t* juliaVarIndexes = jl_fieldref(juliaCallResult, 1); // Vector{Int64}
            jl_value_t* juliaTermCoeffs = jl_fieldref(juliaCallResult, 2); // Vector{Float64}

            // Extract objectiveValue
            lastObjValue = jl_unbox_float64(juliaObj);
            env->output->outputInfo(fmt::format("        Objective value: {}", lastObjValue));
            
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
    jl_eval_string("include(\"//home//ubuntu//SHOT-soshyp//ThirdParty//soshyp//main.jl\")");
    env->output->outputDebug("        Loading Julia module.");
    jl_eval_string("using .soshyp");
    env->output->outputDebug("        Julia module loaded.");

    if(jl_exception_occurred())
    {
        env->output->outputError(fmt::format("        Julia exception when initializing environment"));
        printJuliaError(env);
        exit(1);
    }

    // Get a handle to the function
    jl_module_t* module = (jl_module_t*)jl_eval_string("soshyp");

    if(jl_exception_occurred())
    {
        env->output->outputError(fmt::format("        Julia exception when loading module"));
        printJuliaError(env);
        exit(1);
    }

    jl_function_t* funcPrepareProblem = jl_get_function(module, "prepare_problem");

    if(funcPrepareProblem == nullptr)
    {
        env->output->outputError("        Function prepare_problem not found!");
        exit(1);
    }

    // Write the reformulated problem to a file
    auto filename
        = fmt::format("{0}/lassarre_problem.txt", env->settings->getSetting<std::string>("Debug.Path", "Output"));
    std::stringstream problem;
    problem << env->reformulatedProblem;
    Utilities::writeStringToFile(filename, problem.str());

    // Prepare the arguments
    jl_value_t* problemPath = jl_cstr_to_string(filename.c_str());
    jl_value_t* directory = jl_cstr_to_string(""); // directory already included in filename
    jl_value_t* argQuiet = jl_box_bool(outputQuiet); // quiet

    // Create an array of arguments
    jl_value_t* args[3] = { problemPath, directory, argQuiet};
    
    jl_value_t* prepareProblemStatus = jl_call(funcPrepareProblem, args, 3);

    if(jl_exception_occurred())
    {
        env->output->outputError(fmt::format("        Julia exception when preparing problem"));
        printJuliaError(env);

        exit(1);
    }

    for(auto& V : env->reformulatedProblem->allVariables)
        variableNames.push_back(V->name);
}

int main(int argc, const char* argv[])
{
    // Check if the correct number of arguments is provided
    if(argc <= 4)
    {
        std::cerr << "Usage: " << argv[0] << " <problem_filename> <output_directory> <options_filename> <order=2,3,...> [quiet=true/false] [sparsity=all/single/cliques]"
                  << std::endl;
        return 1;
    }

    // Extract arguments
    std::string problemFilename = argv[1];
    std::string outputDirectory = argv[2];
    std::string optionsFilename = argv[3];

    order = argv[4] ? std::stoi(argv[4]) : 2; // Default order is 2 if not provided, if order is 0 then run normal SHOT on problem
    outputQuiet = (argc >= 5 && std::string(argv[5]) == "true");
    
    // Parse sparsity argument: can be "all", "single", or "cliques" (default)
    if (argc >= 6) {
        std::string sparsityArg = argv[6];
        if (sparsityArg == "all" || sparsityArg == "single" || sparsityArg == "cliques") {
            sparsity = sparsityArg;
        } else {
            sparsity = "all"; // default fallback
        }
    } else {
        sparsity = "all"; // default when no argument provided
    }

    std::cout << " Output directory: " << outputDirectory << std::endl;

    if (order != 0)
    {
        std::cout << " Lasserre order is set to: " << order << std::endl;
        std::cout << " Sparsity parameter set to: " << sparsity << std::endl;
    }
    else    
    {
        std::cout << " Using regular SHOT nonconvex strategy. " << order << std::endl;
    }


    // Create a Solver instance
    std::unique_ptr<Solver> solver = std::make_unique<Solver>();
    auto env = solver->getEnvironment();

    env->report->outputSolverHeader();

    // Load options from the options file
    solver->setOptionsFromFile(optionsFilename);

    // Update some options
    std::string debugPath = outputDirectory;
    solver->updateSetting("Debug.Path", "Output", debugPath);
    solver->updateSetting("Debug.Enable", "Output", true);

    if (order != 0) 
    {
        solver->updateSetting("Reformulation.ObjectiveFunction.Epigraph.Use", "Model", true);
        solver->updateSetting("CutStrategy", "Dual", static_cast<int>(ES_HyperplaneCutStrategy::OnlyExternal));
        solver->updateSetting("HyperplaneCuts.Delay", "Dual", false);
        solver->updateSetting("Convexity.AssumeConvex", "Model", true);
    }
    
    solver->updateSetting("MIP.Solver", "Dual", static_cast<int>(ES_MIPSolver::Cbc));

    solver->updateSetting("Relaxation.Use", "Dual", false);
    solver->updateSetting("Console.Iteration.Detail", "Output", static_cast<int>(ES_IterationOutputDetail::Full));

    std::string logFilename = outputDirectory + "/SHOT.log";
    solver->setLogFile(logFilename);

    // Load the problem file
    if(!solver->setProblem(problemFilename))
    {
        std::cerr << "Error: Unable to load problem file: " << problemFilename << std::endl;
        return 1;
    }

    env->report->outputProblemInstanceReport();
    env->report->outputOptionsReport();

    if (order != 0) 
    {
        // Registers a callback that is activated every time a new primal solution is found
        // Register the callback function
        solver->registerCallback(
            E_EventType::ExternalHyperplaneSelection, [&env](std::any args) { externalHyperplaneSelection(env, args); });
    


        // Registers a callback that terminates if the Julia objective value is small enough
        solver->registerCallback(E_EventType::UserTerminationCheck, [&env](std::any args) 
        {
            if (lastObjValue < 1e-6)
            {
                std::cout << "Callback activated. Terminating since objective value " << lastObjValue << " < 1e-6.\n";
                env->tasks->terminate();
            }
        }
    );
        // Initialize the Julia environment
        std::cout << " \n Initializing Julia environment..." << std::endl;
        initializeJulia(env);
    }
    
    // Solve the problem
    if(!solver->solveProblem())
    {
        std::cerr << "Error: Problem solving failed." << std::endl;
        return 1;
    }

    solver->finalizeSolution();
    env->report->outputSolutionReport();

    // Write OSRL output to file
    auto osrl = solver->getResultsOSrL();
    std::string osrlFilename = outputDirectory + "/SHOT.osrl";

    if(!Utilities::writeStringToFile(osrlFilename, osrl))
    {
        std::cerr << "Error: Unable to write OSRL file to: " << osrlFilename << std::endl;
        return 1;
    }
    else
    {
        std::cout << "OSRL results written to: " << osrlFilename << std::endl;
    }

        // Write trace file
    auto trc = solver->getResultsTrace();
    std::string trcFilename = outputDirectory + "/SHOT.trc";

    if(!Utilities::writeStringToFile(trcFilename, trc))
    {
        std::cerr << "Error: Unable to write trace file to: " << trcFilename << std::endl;
        return 1;
    }
    else
    {
        std::cout << "Trace results written to: " << trcFilename << std::endl;
    }

    return 0;
}