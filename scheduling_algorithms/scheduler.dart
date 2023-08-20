import 'dart:collection';
import '../process.dart';

abstract class Scheduler {
  List<Process> newProcesses = List<Process>.empty(growable: true);
  Queue<Process> readyQueue = Queue<Process>();

  void admitProcesses(List<Process> arrivedProcesses) {
    if (arrivedProcesses.isEmpty) return;

    readyQueue.addAll(arrivedProcesses);

    // NOTE: I'm removing processes from newProcesses one at a time
    // once they get added to readyQueue so that they don't get picked up again
    newProcesses = newProcesses
        .where((newProcess) => !arrivedProcesses.contains(newProcess))
        .toList();
  }
}
