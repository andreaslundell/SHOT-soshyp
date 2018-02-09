#pragma once
#include "../NLPSolver/NLPSolverCuttingPlaneMinimax.h"
#include "TaskBase.h"
#include "../ProcessInfo.h"

#include "../NLPSolver/INLPSolver.h"
#include "../NLPSolver/NLPSolverIpoptMinimax.h"
#include "../NLPSolver/NLPSolverIpoptRelaxed.h"

class TaskFindInteriorPoint: public TaskBase
{
	public:
		TaskFindInteriorPoint();
		virtual ~TaskFindInteriorPoint();

		virtual void run();
		virtual std::string getType();

	private:
		std::vector<std::unique_ptr<INLPSolver>> NLPSolvers;

};

class TaskExceptionInteriorPoint: public std::exception
{
	public:

		TaskExceptionInteriorPoint(std::string msg) :
				explanation(msg)
		{
		}

		const char * what() const throw ()
		{
			std::stringstream message;
			message << explanation;
			return message.str().c_str();
		}
	private:
		std::string explanation;

};
