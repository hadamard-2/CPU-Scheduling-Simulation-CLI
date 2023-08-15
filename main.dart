import 'SchedulingAlgorithms/first_come_first_serve.dart';
import 'gantt_chart.dart';
import 'process.dart';
import 'report.dart';

void main() {
  var scheduler1 = FCFS();
  scheduler1.newProcesses.addAll([
    Process(name: 'p1', arrivalTime: 2, burstTime: 2),
    Process(name: 'p2', arrivalTime: 5, burstTime: 4),
    Process(name: 'p3', arrivalTime: 16, burstTime: 3)
  ]);

  scheduler1.scheduleJobs();
  GanttChart ganttChart = scheduler1.scheduleCPU();

  print(ganttChart);
  // I cannot do this since there are no new processes
  Report schedulingReport = Report(scheduler1.newProcesses, ganttChart);
  schedulingReport.drawTable();
}
