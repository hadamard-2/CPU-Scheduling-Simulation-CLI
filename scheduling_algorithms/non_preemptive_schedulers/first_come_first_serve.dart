import 'non_preemptive_scheduler.dart';

// First Come First Serve Scheduling
class FCFS extends NonPreemptiveScheduler {
  // selects which processes should be brought into the ready queue
  void scheduleJobs() {
    while (newProcesses.length != 0) {
      var arrivedProcess = newProcesses.reduce((current, next) =>
          current.arrivalTime <= next.arrivalTime ? current : next);
      admitProcesses([arrivedProcess]);
    }
  }
}
