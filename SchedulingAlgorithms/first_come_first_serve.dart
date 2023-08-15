import 'dart:math';

import '../bar.dart';
import '../gantt_chart.dart';
import '../process.dart';
import '../time_interval.dart';
import 'scheduler.dart';

// First Come First Serve Scheduling
class FCFS extends Scheduler {
// service time & completion time for each process
  int serviceTime = 0;
  int completionTime = 0;

  // selects which processes should be brought into the ready queue
  void scheduleJobs() {
    while (newProcesses.length != 0) {
      var readyProcess = newProcesses.reduce((current, next) =>
          current.arrivalTime < next.arrivalTime ? current : next);
      admit(readyProcess);
      newProcesses.remove(readyProcess);
    }
  }

  // selects which process should be executed next and allocates CPU
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
  Bar run(Process process) {
    var executionTimeInterval =
        TimeInterval(serviceTime, serviceTime + process.burstTime);
    return Bar(executionTimeInterval, process);
  }
}
