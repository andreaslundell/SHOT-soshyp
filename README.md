![CMake](https://github.com/coin-or/SHOT/workflows/CMake/badge.svg)
[![License](https://img.shields.io/badge/License-EPL%202.0-red.svg)](https://opensource.org/licenses/EPL-1.0)


# The Supporting Hyperplane Optimization Toolkit

<img align="right" width="200" src="SHOT.png">*SHOT is a software for solving mathematical optimization problems of the mixed-integer nonlinear programming (MINLP) class. In addition to MINLP problems, SHOT can also be used for subclasses such as NLP and MI(QC)QP.*

Originally SHOT was intended for convex MINLP problems only, but as of version 1.0 it also has functionality to solve nonconvex MINLP problems as a heuristic method without providing any guarantees of global optimality. SHOT can solve certain nonconvex problem types to global optimality as well, and the bounds for the objective function value are guaranteed for nonconvex problems as well.

**SHOT can be used**
- as a console application,
- from [GAMS](https://www.gams.com),
- on the [NEOS Server](https://neos-server.org/neos/solvers/minco:SHOT/GAMS.html),
- from any modeling system that can use ASL, such as
  - [Pyomo/Python](https://www.pyomo.org), 
  - [JuMP/Julia](https://github.com/JuliaOpt/AmplNLWriter.jl), and 
  - [AMPL](https://www.ampl.com),
- using its API implemented in C++.

SHOT requires a MILP solver: [Cplex](https://www.ibm.com/analytics/cplex-optimizer), [Gurobi](https://www.gurobi.com) or [Cbc](https://www.github.com/coin-or/Cbc). In addition an NLP solver is required; currently only [Ipopt](https://www.github.com/coin-or/Ipopt) is supported. If SHOT is interfaced with GAMS, any licensed NLP solver can be used.

The documentation is provided at the project website at https://www.shotsolver.dev.

SHOT is a [COIN-OR project](https://www.coin-or.org), and won the [COIN-OR Cup 2018](https://www.coin-or.org/2018-coin-or-cup-winner/). Project manager is [Andreas Lundell](https://www.researchgate.net/profile/Andreas_Lundell). A full list of contributors is available on the [project website](https://shotsolver.dev/shot/about-shot/contributors).

## Dual bound through polyhedral (outer) approximation

SHOT is based on iteratively creating a tighter polyhedral approximation of the nonlinear feasible set by generating supporting hyperplanes or cutting planes. These linearized problems are then solved with an mixed-integer linear programming (MILP) solver such as CPLEX, Gurobi or Cbc. If CPLEX or Gurobi is used, the subproblems can also include quadratic and bilinear nonlinearities directly; then MIQP or MIQCQP subproblems are solved. 

## Primal bound using heuristics

The solution to the outer approximation problem provides a lower (dual) bound (when solving a minimization problem) to the original problem if the problem is convex. If the problem is nonconvex, convergence to the global optimal solution cannot be guaranteed (but might be achieved for certain classes of problems, cf. [this paper](http://www.optimization-online.org/DB_HTML/2020/03/7691.html). 

To get an upper (primal) bound (when solving a minimization problem) on the optimal solution SHOT utilizes the following heuristics:
- Solving nonlinear programming (NLP) problems where the integer variables have been fixed to valid values. This is done by calling an external NLP solver (e.g. Ipopt).
- By checking solutions from the MIP solver's solution pool for points that fulfill also the nonlinearities in the original MINLP problem.
- By performing root searches. 

## Termination

When the relative or absolute difference (objective gap) between the primal and dual bounds is less than a user-specified value, SHOT terminates with the current primal solution. If the original problem is convex, this is a global solution to the problem. If it is nonconvex, there is normally no guarantee that such a solution can be found, however SHOT will always in addition to the primal solution give a valid lower bound on the solution. 

## Compilation instructions

Instructions for compiling SHOT is available at the [project website](https://shotsolver.dev/shot/about-shot/compiling).

## Solver manual

Instructions for how to use SHOT, e.g. call it from different environments, are provided on the [project website](https://shotsolver.dev/shot/using-shot/getting-started).

## Publications

**SHOT is best described in the paper:**

Lundell, A. Kronqvist, J. and Westerlund, T. *The supporting hyperplane optimization toolkit for convex MINLP*. Journal of Global Optimization (2022). https://link.springer.com/article/10.1007/s10898-022-01128-0

**The features for solving nonconvex MINLP problems are described in the papers:**

Lundell, A. and Kronqvist, J., *Polyhedral approximation strategies for nonconvex mixed-integer nonlinear programming in SHOT*. Journal of Global Optimization (2021). https://doi.org/10.1007/s10898-021-01006-1

Lundell, A. and Kronqvist, J. *On Solving Nonconvex MINLP Problems with SHOT* (2019). In: Le Thi H., Le H., Pham Dinh T. (editors) Optimization of Complex Systems: Theory, Models, Algorithms and Applications. WCGO 2019. Advances in Intelligent Systems and Computing, vol 991. Springer, Cham.
