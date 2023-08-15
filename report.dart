import 'gantt_chart.dart';
import 'process.dart';

class Report {
  List<Process> processes;

  Report(this.processes, GanttChart ganttChart) {
    for (Process process in processes) {
      process.readGanttChart(ganttChart);
      process.computeResponseTime();
      process.computeTurnAroundTime();
      process.computeWaitingTime();
    }
  }

  void drawTable() {
    print('\tAT\tBT\tWT\tTRT\tRT');
    for (Process process in processes) {
      print(
          '${process.name}\t${process.arrivalTime}\t${process.burstTime}\t${process.waitingTime}\t${process.turnAroundTime}\t${process.responseTime}');
    }
  }
}
