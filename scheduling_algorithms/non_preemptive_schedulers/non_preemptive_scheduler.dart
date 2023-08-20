import 'dart:math';

import '../../gantt_chart/bar.dart';
import '../../gantt_chart/gantt_chart.dart';
import '../../gantt_chart/time_interval.dart';
import '../../process.dart';
import '../scheduler.dart';

abstract class NonPreemptiveScheduler extends Scheduler {
  // service time of the current process
  int serviceTime = 0;
  // completion time of the previous process
  int completionTime = 0;

  void scheduleJobs();

  Bar run(Process process) {
    var executionTimeInterval =
        TimeInterval(serviceTime, serviceTime + process.burstTime);
    return Bar(executionTimeInterval, process);
  }

  // selects which process should be executed next and allocates CPU
  GanttChart scheduleCPU() {
    // fresh start
    serviceTime = 0;
    completionTime = 0;

    GanttChart ganttChart = GanttChart();

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
