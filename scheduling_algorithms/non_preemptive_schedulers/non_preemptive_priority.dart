import 'dart:math';

import 'non_preemptive_scheduler.dart';

// Non-preemptive Priority Scheduling
class NPPriority extends NonPreemptiveScheduler {
  @override
  void scheduleJobs() {
    // of the processes that have arrived, choose the job with the highest priority
    // (least priority number) and add to the ready queue

    var earliestProcess =
        newProcesses.reduce((a, b) => a.arrivalTime <= b.arrivalTime ? a : b);
    completionTime = earliestProcess.arrivalTime;

    while (newProcesses.length != 0) {
      var arrivedProcesses = newProcesses
          .where((process) => process.arrivalTime <= completionTime)
          .toList();
      if (arrivedProcesses.isNotEmpty) {
        // admitting an arrived process that takes the least time to execute
        // NOTE: this is the only part that differs from NPSJF
        var arrivedProcessHighestPriority = arrivedProcesses
            .reduce((a, b) => a.priority! <= b.priority! ? a : b);
        admitProcesses([arrivedProcessHighestPriority]);

        serviceTime =
            max(completionTime, arrivedProcessHighestPriority.arrivalTime);

        // I need to check what processes have arrived:
        // as soon as a process completes executing
        completionTime = serviceTime + arrivedProcessHighestPriority.burstTime;
      }
    }
  }
}
