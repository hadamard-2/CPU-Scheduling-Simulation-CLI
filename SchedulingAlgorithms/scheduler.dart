import 'dart:collection';
import '../bar.dart';
import '../gantt_chart.dart';
import '../process.dart';

abstract class Scheduler {
  List<Process> newProcesses = List<Process>.empty(growable: true);
  Queue<Process> readyQueue = Queue<Process>();

  // for preemptive algorithms only
  int hasANewProcessArrived(int time) {
    return newProcesses.indexWhere((process) => process.arrivalTime == time);
  }

  // for both preemptive and non-preemptive algorithms
  void admit(Process process) {
    readyQueue.add(process);
  }

  void scheduleJobs();
  Bar run(Process process);
  GanttChart scheduleCPU();
}
