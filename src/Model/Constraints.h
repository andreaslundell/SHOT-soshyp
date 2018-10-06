/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE 
   This software is licensed under the Eclipse Public License 2.0. 
   Please see the README and LICENSE files for more information.
*/

#pragma once
#include "ModelShared.h"
#include "../UtilityFunctions.h"

#include <vector>
#include <string>
#include <memory>
#include <limits>
#include <algorithm>
#include <iostream>
#include <map>

namespace SHOT
{

enum class E_ConstraintClassification
{
    None,
    Linear,
    Quadratic,
    QuadraticConsideredAsNonlinear,
    Signomial,
    Nonlinear,
    GeneralizedSignomial,
    Nonalgebraic
};

enum class E_ConstraintSignType
{
    None,
    Equality,
    LessThan,
    GreaterThan,
    LessThanAndGreaterThan
};

struct ConstraintProperties
{
    E_ConstraintClassification classification;
    E_Curvature curvature;
    E_ConstraintSignType type;

    bool isReformulated = false;

    bool hasLinearTerms = false;
    bool hasSignomialTerms = false;
    bool hasQuadraticTerms = false;
    bool hasNonlinearExpression = false;
    bool hasNonalgebraicPart = false; // E.g. for external functions
};

class Constraint
{
  public:
    virtual ~Constraint(){};

    int index = -1;
    std::string name;

    ConstraintProperties properties;

    ProblemPtr ownerProblem;

    virtual bool isFulfilled(const VectorDouble &point) = 0;

    void takeOwnership(ProblemPtr owner);

    virtual std::ostream &print(std::ostream &) const = 0;
};

std::ostream &operator<<(std::ostream &stream, ConstraintPtr constraint);
std::ostream &operator<<(std::ostream &stream, const Constraint &constraint);

class NumericConstraint : public Constraint, public std::enable_shared_from_this<NumericConstraint>
{
  public:
    double valueLHS = -std::numeric_limits<double>::infinity();
    double valueRHS = std::numeric_limits<double>::infinity();

    virtual double calculateFunctionValue(const VectorDouble &point) = 0;
    virtual Interval calculateFunctionValue(const IntervalVector &intervalVector) = 0;

    virtual SparseVariableVector calculateGradient(const VectorDouble &point) = 0;

    virtual NumericConstraintValue calculateNumericValue(const VectorDouble &point);

    virtual bool isFulfilled(const VectorDouble &point) override;

    virtual std::shared_ptr<NumericConstraint> getPointer() = 0;
};

class LinearConstraint : public NumericConstraint
{
  public:
    LinearTerms linearTerms;

    LinearConstraint(){};

    LinearConstraint(int index, std::string name, double LHS, double RHS)
    {
        index = index;
        name = name;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    LinearConstraint(int index, std::string name, LinearTerms linTerms, double LHS, double RHS)
    {
        index = index;
        name = name;
        linearTerms = linTerms;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    void add(LinearTerms terms);
    void add(LinearTermPtr term);

    virtual double calculateFunctionValue(const VectorDouble &point) override;
    virtual Interval calculateFunctionValue(const IntervalVector &intervalVector);

    virtual bool isFulfilled(const VectorDouble &point) override;

    virtual SparseVariableVector calculateGradient(const VectorDouble &point);

    virtual NumericConstraintValue calculateNumericValue(const VectorDouble &point) override;

    virtual std::shared_ptr<NumericConstraint> getPointer() override;

    std::ostream &print(std::ostream &stream) const override;
};

typedef std::shared_ptr<LinearConstraint> LinearConstraintPtr;
typedef std::vector<LinearConstraintPtr> LinearConstraints;

std::ostream &operator<<(std::ostream &stream, LinearConstraintPtr constraint);

class QuadraticConstraint : public LinearConstraint
{
  public:
    QuadraticTerms quadraticTerms;

    QuadraticConstraint(){};

    QuadraticConstraint(int index, std::string name, double LHS, double RHS)
    {
        index = index;
        name = name;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    QuadraticConstraint(int index, std::string name, QuadraticTerms quadTerms, double LHS, double RHS)
    {
        index = index;
        name = name;
        quadraticTerms = quadTerms;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    QuadraticConstraint(int index, std::string name, LinearTerms linTerms, QuadraticTerms quadTerms, double LHS, double RHS)
    {
        index = index;
        name = name;
        linearTerms = linTerms;
        quadraticTerms = quadTerms;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    void add(LinearTerms terms);
    void add(LinearTermPtr term);
    void add(QuadraticTerms terms);
    void add(QuadraticTermPtr term);

    virtual double calculateFunctionValue(const VectorDouble &point) override;
    virtual Interval calculateFunctionValue(const IntervalVector &intervalVector);

    virtual bool isFulfilled(const VectorDouble &point) override;

    virtual SparseVariableVector calculateGradient(const VectorDouble &point);

    virtual NumericConstraintValue calculateNumericValue(const VectorDouble &point) override;

    virtual std::shared_ptr<NumericConstraint> getPointer() override;

    std::ostream &print(std::ostream &stream) const override;
};

std::ostream &operator<<(std::ostream &stream, QuadraticConstraintPtr constraint);

class NonlinearConstraint : public QuadraticConstraint
{
  public:
    NonlinearExpressionPtr nonlinearExpression;
    FactorableFunctionPtr factorableFunction;
    std::vector<std::pair<VariablePtr, FactorableFunction>> symbolicSparseJacobian;

    NonlinearConstraint(){};

    NonlinearConstraint(int index, std::string name, double LHS, double RHS)
    {
        index = index;
        name = name;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    NonlinearConstraint(int index, std::string name, NonlinearExpressionPtr expression, double LHS, double RHS)
    {
        index = index;
        name = name;
        nonlinearExpression = expression;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    NonlinearConstraint(int index, std::string name, QuadraticTerms quadTerms, NonlinearExpressionPtr expression, double LHS, double RHS)
    {
        index = index;
        name = name;
        quadraticTerms = quadTerms;
        nonlinearExpression = expression;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    NonlinearConstraint(int index, std::string name, LinearTerms linTerms, NonlinearExpressionPtr expression, double LHS, double RHS)
    {
        index = index;
        name = name;
        linearTerms = linTerms;
        nonlinearExpression = expression;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    NonlinearConstraint(int index, std::string name, LinearTerms linTerms, QuadraticTerms quadTerms, NonlinearExpressionPtr expression, double LHS, double RHS)
    {
        index = index;
        name = name;
        linearTerms = linTerms;
        quadraticTerms = quadTerms;
        nonlinearExpression = expression;
        valueLHS = LHS;
        valueRHS = RHS;
    };

    void add(LinearTerms terms);
    void add(LinearTermPtr term);
    void add(QuadraticTerms terms);
    void add(QuadraticTermPtr term);
    void add(NonlinearExpressionPtr expression);

    void updateFactorableFunction();

    virtual double calculateFunctionValue(const VectorDouble &point) override;

    virtual SparseVariableVector calculateGradient(const VectorDouble &point);

    virtual Interval calculateFunctionValue(const IntervalVector &intervalVector);

    virtual bool isFulfilled(const VectorDouble &point) override;

    virtual NumericConstraintValue calculateNumericValue(const VectorDouble &point) override;

    virtual std::shared_ptr<NumericConstraint> getPointer() override;

    std::ostream &print(std::ostream &stream) const override;
};

std::ostream &operator<<(std::ostream &stream, NonlinearConstraintPtr constraint);
std::ostream &operator<<(std::ostream &stream, NumericConstraintPtr constraint);
std::ostream &operator<<(std::ostream &stream, LinearConstraintPtr constraint);
std::ostream &operator<<(std::ostream &stream, QuadraticConstraintPtr constraint);
std::ostream &operator<<(std::ostream &stream, NonlinearConstraintPtr constraint);
} // namespace SHOT