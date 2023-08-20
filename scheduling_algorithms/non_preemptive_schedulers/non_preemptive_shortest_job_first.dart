import 'dart:math';

import 'non_preemptive_scheduler.dart';

// Non-preemptive Shortest Job First Scheduling
class NPSJF extends NonPreemptiveScheduler {
  // selects which processes should be brought to the ready queue
  @override
  void scheduleJobs() {
    // of the processes that have arrived, choose the shortest one and add to the ready queue

    var earliestProcess =
        newProcesses.reduce((a, b) => a.arrivalTime <= b.arrivalTime ? a : b);
    completionTime = earliestProcess.arrivalTime;

    while (newProcesses.length != 0) {
      var arrivedProcesses = newProcesses
          .where((process) => process.arrivalTime <= completionTime)
          .toList();
      if (arrivedProcesses.isNotEmpty) {
        // admitting an arrived process that takes the least time to execute
        var arrivedProcessWithLeastBT = arrivedProcesses
            .reduce((a, b) => a.burstTime <= b.burstTime ? a : b);
        admitProcesses([arrivedProcessWithLeastBT]);

        serviceTime =
            max(completionTime, arrivedProcessWithLeastBT.arrivalTime);

        // I need to check what processes have arrived:
        // as soon as a process completes executing
        completionTime = serviceTime + arrivedProcessWithLeastBT.burstTime;
      }
    }
  }
}
