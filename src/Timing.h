/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE
   This software is licensed under the Eclipse Public License 2.0.
   Please see the README and LICENSE files for more information.
*/

#pragma once
#include "Environment.h"
#include "Timer.h"
#include "Output.h"

#include <algorithm>
#include <vector>

namespace SHOT
{

/**
 * @class Timing
 * @brief A timer management class for tracking multiple named timers
 * 
 * This class manages a collection of Timer objects, allowing creation and
 * manipulation of multiple named timers. It provides a centralized interface
 * for timing different parts of the SHOT optimization process.
 */
class Timing
{
public:
    /**
     * @brief Constructs a Timing object with reference to the SHOT environment
     * @param envPtr Pointer to the SHOT environment
     */
    inline Timing(EnvironmentPtr envPtr) { env = envPtr; };

    /**
     * @brief Destructor that clears all timers
     */
    inline ~Timing() { timers.clear(); }

    /**
     * @brief Creates a new timer with the specified name and description
     * @param name The unique name identifier for the timer
     * @param description A descriptive text for the timer
     */
    inline void createTimer(std::string name, std::string description) { timers.emplace_back(name, description); }

    /**
     * @brief Starts the timer with the specified name
     * @param name The name of the timer to start
     * @note If the timer is not found, an error message is output
     */
    inline void startTimer(std::string name)
    {
        auto timer = std::find_if(timers.begin(), timers.end(), [name](Timer const& T) { return (T.name == name); });

        if(timer == timers.end())
        {
            env->output->outputError("Timer with name  \"" + name + "\" not found!");
            return;
        }

        timer->start();
    }

    inline void stopTimer(std::string name)
    {
        auto timer = std::find_if(timers.begin(), timers.end(), [name](Timer const& T) { return (T.name == name); });

        if(timer == timers.end())
        {
            env->output->outputError("Timer with name  \"" + name + "\" not found!");
            return;
        }

        timer->stop();
    }

    inline void restartTimer(std::string name)
    {
        auto timer = std::find_if(timers.begin(), timers.end(), [name](Timer const& T) { return (T.name == name); });

        if(timer == timers.end())
        {
            env->output->outputError("Timer with name  \"" + name + "\" not found!");
            return;
        }

        timer->restart();
    }

    /**
     * @brief Gets the elapsed time for the timer with the specified name
     * @param name The name of the timer to query
     * @return The elapsed time in seconds, or 0.0 if timer not found
     * @note If the timer is not found, an error message is output
     */
    inline double getElapsedTime(std::string name)
    {
        auto timer = std::find_if(timers.begin(), timers.end(), [name](Timer const& T) { return (T.name == name); });

        if(timer == timers.end())
        {
            env->output->outputError("Timer with name  \"" + name + "\" not found!");
            return (0.0);
        }

        return (timer->elapsed());
    }

    /**
     * @brief Sets the elapsed time for a timer to a specific value and stops it
     * @param name The name of the timer to modify
     * @param value The time value in seconds to set
     * @note If the timer is not found, an error message is output
     * @note The timer will be stopped after setting the value
     */
    inline void setTimerValue(std::string name, double value)
    {
        auto timer = std::find_if(timers.begin(), timers.end(), [name](Timer const& T) { return (T.name == name); });

        if(timer == timers.end())
        {
            env->output->outputError("Timer with name  \"" + name + "\" not found!");
            return;
        }

        timer->setTime(value);
    }

    /**
     * @brief Adds a specific amount of time to a timer's elapsed time and stops it
     * @param name The name of the timer to modify
     * @param value The time value in seconds to add
     * @note If the timer is not found, an error message is output
     * @note The timer will be stopped after adding the value
     */
    inline void addTimerValue(std::string name, double value)
    {
        auto timer = std::find_if(timers.begin(), timers.end(), [name](Timer const& T) { return (T.name == name); });

        if(timer == timers.end())
        {
            env->output->outputError("Timer with name  \"" + name + "\" not found!");
            return;
        }

        timer->addTime(value);
    }

    std::vector<Timer> timers; ///< Collection of all managed timers

private:
    EnvironmentPtr env; ///< Pointer to the SHOT environment for error reporting
};

} // namespace SHOT