/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE
   This software is licensed under the Eclipse Public License 2.0.
   Please see the README and LICENSE files for more information.
*/

#pragma once

#include "Enums.h"

#include <limits>
#include <memory>
#include <sstream>
#include <string>
#include <vector>

// For DLL support in Windows
#if defined(_WIN32)
#if !defined(STDCALL)
#define STDCALL __stdcall
#endif
#if !defined(DllExport)
#define DllExport __declspec(dllexport)
#endif
#else
#if !defined(STDCALL)
#define STDCALL
#endif
#if !defined(DllExport)
#ifdef __GNUC__
#define DllExport __attribute__((__visibility__("default")))
#else
#define DllExport
#endif
#endif
#endif

// Fix for missing NAN in Visual Studio
#ifdef WIN32
#ifndef NAN
static const unsigned long __nan[2] = { 0xffffffff, 0x7fffffff };
#define NAN (*(const float*)__nan)
#endif
#else
#include <cmath> // For NAN
#endif

namespace SHOT
{
const double SHOT_DBL_MIN = std::numeric_limits<double>::lowest();
const double SHOT_DBL_MAX = std::numeric_limits<double>::max();
const double SHOT_DBL_INF = std::numeric_limits<double>::infinity();
const double SHOT_DBL_EPS = std::numeric_limits<double>::epsilon();
const double SHOT_DBL_SIG_MIN = 0.00001; // Minimal value for base in power function if power is noninteger
const int SHOT_INT_MAX = std::numeric_limits<int>::max();
const long SHOT_LONG_MAX = std::numeric_limits<long>::max();

class Results;
class Settings;
class Model;
class Problem;
class ReformulatedProblem;
class IModelingSystem;
class IMIPSolver;
class Output;
class Report;
class TaskHandler;
class EventHandler;
class Timing;
class Iteration;
class DualSolver;
class PrimalSolver;

class Constraint;
class NumericConstraint;

using ResultsPtr = std::shared_ptr<Results>;
using SettingsPtr = std::shared_ptr<Settings>;
using ModelPtr = std::shared_ptr<Model>;
using ProblemPtr = std::shared_ptr<Problem>;
using ReformulatedProblemPtr = std::shared_ptr<ReformulatedProblem>;
using ModelingSystemPtr = std::shared_ptr<IModelingSystem>;
using MIPSolverPtr = std::shared_ptr<IMIPSolver>;
using OutputPtr = std::shared_ptr<Output>;
using EventHandlerPtr = std::shared_ptr<EventHandler>;
using ReportPtr = std::shared_ptr<Report>;
using TaskHandlerPtr = std::shared_ptr<TaskHandler>;
using TimingPtr = std::shared_ptr<Timing>;
using DualSolverPtr = std::shared_ptr<DualSolver>;
using PrimalSolverPtr = std::shared_ptr<PrimalSolver>;
using IterationPtr = std::shared_ptr<Iteration>;

using ConstraintPtr = std::shared_ptr<Constraint>;
using NumericConstraintPtr = std::shared_ptr<NumericConstraint>;

using PairInteger = std::pair<int, int>;
using PairDouble = std::pair<double, double>;
using PairString = std::pair<std::string, std::string>;

using VectorDouble = std::vector<double>;
using VectorInteger = std::vector<int>;
using VectorString = std::vector<std::string>;
using VectorPairString = std::vector<PairString>;

struct PairIndexValue
{
    int index;
    double value;

public:
    PairIndexValue() = default;
    PairIndexValue(int index, double value) : index(index), value(value) {};
};

struct PairCoordinateValue
{
    PairInteger indexes;
    double value;
};

struct SolutionPoint
{
    VectorDouble point;
    double objectiveValue;
    int iterFound;
    PairIndexValue maxDeviation;
    bool isRelaxedPoint = false;
    double hashValue;
};

struct InteriorPoint
{
    VectorDouble point;
    PairIndexValue maxDevatingConstraint;
};

struct PrimalSolution
{
    VectorDouble point;
    E_PrimalSolutionSource sourceType;
    std::string sourceDescription;
    double objValue;
    int iterFound;
    PairIndexValue maxDevatingConstraintLinear { -1, SHOT_DBL_INF };
    PairIndexValue maxDevatingConstraintQuadratic { -1, SHOT_DBL_INF };
    PairIndexValue maxDevatingConstraintNonlinear { -1, SHOT_DBL_INF };
    double maxIntegerToleranceError; // The maximum integer error before rounding
    bool boundProjectionPerformed = false; // Has the variable bounds been corrected to either upper or lower bounds?
    bool integerRoundingPerformed = false; // Has the integers been rounded?
    bool displayed = false; // Has the primal solution been displayed on console?
};

struct PrimalFixedNLPCandidate
{
    VectorDouble point;
    E_PrimalNLPSource sourceType;
    double objValue;
    int iterFound;
    PairIndexValue maxDevatingConstraint;
    double discreteVariablePointHash;
};

struct DualSolution
{
    VectorDouble point;
    E_DualSolutionSource sourceType;
    double objValue;
    int iterFound;
    bool displayed; // Has the dual solution been displayed on console?
};

struct Hyperplane
{
    NumericConstraintPtr sourceConstraint;
    int sourceConstraintIndex; // -1 if objective function
    VectorDouble generatedPoint;
    double objectiveFunctionValue; // Used for the objective cuts only
    E_HyperplaneSource source = E_HyperplaneSource::None;
    bool isObjectiveHyperplane = false;
    bool isSourceConvex = false;
    double pointHash;
};

struct GeneratedHyperplane : Hyperplane
{
    bool isLazy = false;
    bool isRemoved = false;
    int iterationGenerated = -1;
};

struct IntegerCut
{
    VectorInteger variableIndexes;
    VectorInteger variableValues;
    E_IntegerCutSource source = E_IntegerCutSource::None;
    bool areAllVariablesBinary = false;
    int iterationGenerated = -1;
    double pointHash;
};

struct SolutionStatistics
{
    int numberOfIterations = 0;

    int numberOfProblemsLP = 0;
    int numberOfProblemsQP = 0;
    int numberOfProblemsQCQP = 0;
    int numberOfProblemsFeasibleMILP = 0;
    int numberOfProblemsOptimalMILP = 0;
    int numberOfProblemsFeasibleMIQP = 0;
    int numberOfProblemsOptimalMIQP = 0;
    int numberOfProblemsFeasibleMIQCQP = 0;
    int numberOfProblemsOptimalMIQCQP = 0;

    int numberOfBoundingProblemsLP = 0;
    int numberOfBoundingProblemsQP = 0;
    int numberOfBoundingProblemsQCQP = 0;
    int numberOfBoundingProblemsFeasibleMILP = 0;
    int numberOfBoundingProblemsOptimalMILP = 0;
    int numberOfBoundingProblemsFeasibleMIQP = 0;
    int numberOfBoundingProblemsOptimalMIQP = 0;
    int numberOfBoundingProblemsFeasibleMIQCQP = 0;
    int numberOfBoundingProblemsOptimalMIQCQP = 0;

    int numberOfFunctionEvalutions = 0;
    int numberOfGradientEvaluations = 0;

    int numberOfProblemsMinimaxLP = 0;

    int numberOfProblemsFixedNLP = 0;

    int numberOfConstraintsRemovedInPresolve = 0;
    int numberOfVariableBoundsTightenedInPresolve = 0;

    int numberOfHyperplanesWithConvexSource = 0;
    int numberOfHyperplanesWithNonconvexSource = 0;
    int numberOfIntegerCuts = 0;

    int numberOfIterationsWithDualStagnation = 0;
    int lastIterationWithSignificantDualUpdate = 0;
    int numberOfIterationsWithPrimalStagnation = 0;
    int lastIterationWithSignificantPrimalUpdate = 0;
    int numberOfIterationsWithoutNLPCallMIP = 0;

    int iterationLastPrimalBoundUpdate = 0;
    int iterationLastDualBoundUpdate = 0;
    int iterationLastLazyAdded = 0;
    int iterationLastDualCutAdded = 0;

    double timeLastDualBoundUpdate = 0;
    double timeLastFixedNLPCall = 0;

    int numberOfOriginalInteriorPoints = 0;

    int numberOfFoundPrimalSolutions = 0;

    int numberOfExploredNodes = 0;
    int numberOfOpenNodes = 0;

    int numberOfPrimalReductionCutsUpdatesWithoutEffect = 0;
    int numberOfDualRepairsSinceLastPrimalUpdate = 0;

    int numberOfPrimalReductionsPerformed = 0;
    int numberOfSuccessfulDualRepairsPerformed = 0;
    int numberOfUnsuccessfulDualRepairsPerformed = 0;

    int numberOfPrimalImprovementsAfterInfeasibilityRepair = 0;
    int numberOfPrimalImprovementsAfterReductionCut = 0;

    int numberOfDualImprovementsAfterConvexBounding = 0;

    bool hasInfeasibilityRepairBeenPerformedSincePrimalImprovement = false;
    bool hasReductionCutBeenAddedSincePrimalImprovement = false;

    int getNumberOfTotalDualProblems()
    {
        return (numberOfProblemsLP + numberOfProblemsQP + numberOfProblemsFeasibleMILP + numberOfProblemsOptimalMILP
            + numberOfProblemsFeasibleMIQP + numberOfProblemsOptimalMIQP + numberOfProblemsOptimalMIQCQP
            + numberOfProblemsFeasibleMIQCQP);
    };

    int getNumberOfTotalBoundingProblems()
    {
        return (numberOfBoundingProblemsLP + numberOfBoundingProblemsQP + numberOfBoundingProblemsFeasibleMILP
            + numberOfBoundingProblemsOptimalMILP + numberOfBoundingProblemsFeasibleMIQP
            + numberOfBoundingProblemsOptimalMIQP + numberOfBoundingProblemsOptimalMIQCQP
            + numberOfBoundingProblemsFeasibleMIQCQP);
    };
};

class Exception : public std::exception
{
private:
    std::string message;

public:
    Exception(std::string message) : message(message) { }

    inline const char* what() const throw() override { return (message.c_str()); }
};

class VariableNotFoundException : public Exception
{
public:
    VariableNotFoundException(std::string message) : Exception(message) { }
};

class ConstraintNotFoundException : public Exception
{
public:
    ConstraintNotFoundException(std::string message) : Exception(message) { }
};

class OperationNotImplementedException : public Exception
{
public:
    OperationNotImplementedException(std::string message) : Exception(message) { }
};

class NoPrimalSolutionException : public Exception
{
public:
    NoPrimalSolutionException(std::string message) : Exception(message) { }
};

class UnsolvedProblemException : public Exception
{
public:
    UnsolvedProblemException(std::string message) : Exception(message) { }
};

} // namespace SHOT