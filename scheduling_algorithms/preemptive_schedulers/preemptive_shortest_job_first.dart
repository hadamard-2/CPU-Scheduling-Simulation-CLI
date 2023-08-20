import 'dart:collection';
import 'dart:math';

import '../../gantt_chart/bar.dart';
import '../../gantt_chart/gantt_chart.dart';
import '../../process.dart';
import '../../gantt_chart/time_interval.dart';
import 'preemptive_scheduler.dart';

// Preemptive Shortest Job First Scheduling
class PSJF extends PreemptiveScheduler {
  // completion time of the previous process
  int completionTime = 0;
  // service time of the current process
  int serviceTime = 0;
  Process? runningProcess;

  // at every instance of time (1 sec in our case) we check if a new process has arrived
  // if a process has arrived we compare the remaining time of the process being run
  // to the process that has arrived
  // the execution continues with the process who has the least remaining time

  // NOTE: I haven't considered the case where the least remaining time is 0
  Process processWithLeastRemainingTime(
      Process runningProcess, Queue<Process> readyProcesses) {
    if (readyProcesses.isEmpty) {
      return runningProcess;
    }

    var readyProcess = readyProcesses
        .reduce((a, b) => a.remainingTime <= b.remainingTime ? a : b);

    if (runningProcess.remainingTime <= readyProcess.remainingTime) {
      return runningProcess;
    } else {
      return readyProcess;
    }
  }

  void admitProcesses(List<Process> arrivedProcesses) {
    if (arrivedProcesses.isEmpty) return;

    readyQueue.addAll(arrivedProcesses);

    // NOTE: I'm removing processes from newProcesses one at a time
    // once they get added to readyQueue so that they don't get picked up again
    newProcesses = newProcesses
        .where((newProcess) => !arrivedProcesses.contains(newProcess))
        .toList();
  }

  Bar interruptRunningProcess() {
    Bar processBar =
        Bar(TimeInterval(serviceTime, completionTime), runningProcess!);
    // return currently running process back to readyQueue
    readyQueue.add(runningProcess!);

    return processBar;
  }

  GanttChart scheduleJobsAndCPU() {
    newProcesses.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    completionTime = newProcesses.first.arrivalTime;

    // fresh start
    readyQueue.clear();
    GanttChart ganttChart = GanttChart();

    for (int time = completionTime;
        newProcesses.isNotEmpty || readyQueue.isNotEmpty;
        time++) {
      // schedule job
      if (newProcesses.isNotEmpty) {
        var arrivedProcesses = getArrivedProcesses(time);
        // admit processes that have arrived to ready queue
        admitProcesses(arrivedProcesses);
      }

      // schedule CPU
      // if there isn't anything running at the moment
      // start running the ready process (with the least remaining time)
      if (runningProcess == null) {
        Process processToBeRun = readyQueue
            .reduce((a, b) => a.remainingTime <= b.remainingTime ? a : b);

        readyQueue.remove(processToBeRun);

        // run the process for 1 sec
        runningProcess = processToBeRun;
        serviceTime = max(completionTime, runningProcess!.arrivalTime);
        runningProcess!.remainingTime--;
        if (runningProcess!.remainingTime == 0) {
          completionTime = time;
          ganttChart.addProcessBar(
              Bar(TimeInterval(serviceTime, completionTime), runningProcess!));
          runningProcess = null;
        }
      }
      // else, compare the burst time of the running process with the arrived processess
      // and run the process with the least remaining time
      else {
        // decide what process to run for the next second
        Process processToBeRun =
            processWithLeastRemainingTime(runningProcess!, readyQueue);

        if (processToBeRun == runningProcess) {
          // run the process for 1 sec
          runningProcess!.remainingTime--;
          if (runningProcess!.remainingTime == 0) {
            completionTime = time;
            ganttChart.addProcessBar(Bar(
                TimeInterval(serviceTime, completionTime), runningProcess!));
            runningProcess = null;
          }
        }
        // if a process with less remaining time is found
        else {
          // run the process for 1 sec
          runningProcess!.remainingTime--;
          completionTime = time;
          // interrupt the running process
          Bar processBar = interruptRunningProcess();

          // process with the least remaining time should be run for the next second
          readyQueue.remove(processToBeRun);
          runningProcess = processToBeRun;

          serviceTime = time;
          ganttChart.addProcessBar(processBar);
        }
      }
    }

    return ganttChart;
  }
}
