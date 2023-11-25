import 'non_preemptive_scheduler.dart';

// First Come First Serve Scheduling
class FCFS extends NonPreemptiveScheduler {
  // selects which processes should be brought into the ready queue
  void scheduleJobs() {
    while (newProcesses.isNotEmpty) {
      var arrivedProcess =
          newProcesses.reduce((a, b) => a.arrivalTime <= b.arrivalTime ? a : b);
      admitProcesses([arrivedProcess]);
    }
  }
}
