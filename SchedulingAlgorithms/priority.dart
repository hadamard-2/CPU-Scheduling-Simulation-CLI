import 'dart:math';

import '../bar.dart';
import '../gantt_chart.dart';
import '../process.dart';
import '../time_interval.dart';
import 'scheduler.dart';

// Non-preemptive Priority Scheduling
class NPPriority extends Scheduler {
  // completion time of the previous process
  int completionTime = 0;
  // service time of the current process
  int serviceTime = 0;

  @override
  void scheduleJobs() {
    // of the processes that have arrived, choose the job with the highest priority
    // (least priority number) and add to the ready queue

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
        // NOTE: this is the only part that differs from NPSJF
        var arrivedProcess = arrivedProcesses
            .reduce((a, b) => a.priority! <= b.priority! ? a : b);
        admit(arrivedProcess);

        // NOTE: I'm removing processes from newProcesses one at a time
        // once they get added to readyQueue so that they don't get picked up again
        newProcesses.remove(arrivedProcess);

        serviceTime = max(completionTime, arrivedProcess.arrivalTime);

        // other times I need to check what processes have arrived:
        // as soon as a process completes executing
        completionTime = serviceTime + arrivedProcess.burstTime;
      }
    }
  }

  // NOTE: the same as FCFS
  @override
  Bar run(Process process) {
    var executionTimeInterval =
        TimeInterval(serviceTime, serviceTime + process.burstTime);
    return Bar(executionTimeInterval, process);
  }

  // NOTE: the same as FCFS
  @override
  GanttChart scheduleCPU() {
    GanttChart ganttChart = GanttChart();
    // resetting the value of completion time
    completionTime = 0;

    while (readyQueue.isNotEmpty) {
      Process processToBeRun = readyQueue.removeFirst();

      serviceTime = max(completionTime, processToBeRun.arrivalTime);

      Bar processBar = run(processToBeRun);
      completionTime = processBar.timeInterval.end;

      ganttChart.addProcessBar(processBar);
    }

    return ganttChart;
  }
}
