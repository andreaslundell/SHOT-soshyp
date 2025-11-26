/**
   The Supporting Hyperplane Optimization Toolkit (SHOT).

   @author Andreas Lundell, Åbo Akademi University

   @section LICENSE
   This software is licensed under the Eclipse Public License 2.0.
   Please see the README and LICENSE files for more information.
*/

#pragma once
#include <chrono>
#include <string>

/**
 * @class Timer
 * @brief A high-precision timer class for measuring elapsed time
 * 
 * This class provides functionality to measure time intervals with high precision
 * using std::chrono. It supports starting, stopping, and restarting the timer,
 * as well as manually setting or adding time values.
 */
class Timer
{
public:
    Timer() = delete;
    ~Timer() = default;

    /**
     * @brief Constructs a timer with a given name
     * @param timerName The name identifier for this timer
     */
    Timer(std::string timerName)
    {
        restart();
        isRunning = false;
        description = "";
        name = timerName;
    }

    /**
     * @brief Constructs a timer with a name and description
     * @param timerName The name identifier for this timer
     * @param desc A descriptive text for this timer
     */
    Timer(std::string timerName, std::string desc)
    {
        restart();
        isRunning = false;
        description = desc;
        name = timerName;
    }

    std::chrono::time_point<std::chrono::high_resolution_clock> lastStart;

    /**
     * @brief Gets the total elapsed time in seconds
     * @return The elapsed time in seconds. If the timer is running, includes time since last start.
     */
    inline double elapsed()
    {
        if(isRunning)
        {
            std::chrono::duration<double> dur = std::chrono::high_resolution_clock::now() - lastStart;
            double tmpTime = dur.count();
            return (timeElapsed + tmpTime);
        }
        return (timeElapsed);
    }

    /**
     * @brief Restarts the timer, resetting elapsed time to zero and starting measurement
     */
    inline void restart()
    {
        isRunning = true;
        timeElapsed = 0.0;
        lastStart = std::chrono::high_resolution_clock::now();
    }

    /**
     * @brief Stops the timer, accumulating elapsed time
     */
    inline void stop()
    {
        if(!isRunning)
            return;

        std::chrono::duration<double> dur = std::chrono::high_resolution_clock::now() - lastStart;
        double tmpTime = dur.count();
        timeElapsed = timeElapsed + tmpTime;
        isRunning = false;
    }

    /**
     * @brief Starts the timer if it's not already running
     */
    inline void start()
    {
        if(isRunning)
        {
            return;
        }

        isRunning = true;
        lastStart = std::chrono::high_resolution_clock::now();
    }

    /**
     * @brief Sets the timer's elapsed time to a specific value and stops the timer
     * @param time The time value in seconds to set
     */
    inline void setTime(double time)
    {
        timeElapsed = time;
        isRunning = false;
    }

    /**
     * @brief Adds a specific amount of time to the current elapsed time and stops the timer
     * @param time The time value in seconds to add
     */
    inline void addTime(double time)
    {
        timeElapsed += time;
        isRunning = false;
    }

    std::string description; ///< Descriptive text for this timer
    std::string name;        ///< Name identifier for this timer

private:
    double timeElapsed; ///< Total accumulated elapsed time in seconds
    bool isRunning;     ///< Whether the timer is currently running
};
