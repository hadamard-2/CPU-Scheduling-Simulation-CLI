import 'dart:math';

import '../bar.dart';
import '../gantt_chart.dart';
import '../process.dart';
import '../time_interval.dart';
import 'scheduler.dart';

// Non-preemptive Shortest Job First Scheduling
class NPSJF extends Scheduler {
  int completionTime = 0;
  int serviceTime = 0;

  @override
  Bar run(Process process) {
    var executionTimeInterval =
        TimeInterval(serviceTime, serviceTime + process.burstTime);
    return Bar(executionTimeInterval, process);
  }

  @override
  GanttChart scheduleCPU() {
    GanttChart ganttChart = GanttChart();

    while (readyQueue.isNotEmpty) {
      Process processToBeRun = readyQueue.removeFirst();

      // how I dealt with idle time
      serviceTime = max(completionTime, processToBeRun.arrivalTime);

      Bar processBar = run(processToBeRun);
      completionTime = processBar.timeInterval.end;

      ganttChart.addProcessBar(processBar);
    }

    return ganttChart;
  }

  @override
  void scheduleJobs() {
    // of the processes that have arrived, choose the shortest job one and add to the ready queue

    // first time I need to check what processes have arrived:
    // the least arrival time
    newProcesses.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    completionTime = newProcesses.first.arrivalTime;

    while (newProcesses.length != 0) {
      var arrivedProcesses = newProcesses
          .where((process) => process.arrivalTime <= completionTime)
          .toList();
      if (arrivedProcesses.isNotEmpty) {
        // admitting an arrived process that takes the least time to execute
        var readyProcess = arrivedProcesses.reduce((current, next) =>
            current.burstTime < next.burstTime ? current : next);
        admit(readyProcess);
        // NOTE: I'm removing processes from newProcesses one at a time
        // once they get added to readyQueue so that they don't get picked up again
        newProcesses.remove(readyProcess);

        serviceTime = max(completionTime, readyProcess.arrivalTime);

        // other times I need to check what processes have arrived:
        // as soon as a process completes executing
        completionTime = serviceTime + readyProcess.burstTime;
      }
    }
  }
}

// Preemptive Shortest Job First Scheduling
class PSJF extends Scheduler {
  @override
  void scheduleJobs() {
    // TODO: implement scheduleJobs
  }

  @override
  Bar run(Process process) {
    // TODO: implement run
    throw UnimplementedError();
  }

  @override
  GanttChart scheduleCPU() {
    // TODO: implement scheduleCPU
    throw UnimplementedError();
  }
}
