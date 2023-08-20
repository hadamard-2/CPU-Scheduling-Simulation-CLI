import '../../process.dart';
import '../scheduler.dart';

class PreemptiveScheduler extends Scheduler {
  List<Process> getArrivedProcesses(int time) {
    return newProcesses
        .where((process) => process.arrivalTime <= time)
        .toList();
  }
}
