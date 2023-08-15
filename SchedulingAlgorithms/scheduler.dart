import 'dart:collection';
import '../bar.dart';
import '../gantt_chart.dart';
import '../process.dart';

abstract class Scheduler {
  List<Process> newProcesses = List<Process>.empty(growable: true);
  Queue<Process> readyQueue = Queue<Process>();

  int hasANewProcessArrived(int time) {
    return newProcesses.indexWhere((process) => process.arrivalTime == time);
  }

  void admit(Process process) {
    readyQueue.add(process);
  }

  void scheduleJobs();
  Bar run(Process process);
  GanttChart scheduleCPU();
}
