import 'SchedulingAlgorithms/first_come_first_serve.dart';
import 'SchedulingAlgorithms/priority.dart';
import 'SchedulingAlgorithms/shortest_job_first.dart';
import 'gantt_chart.dart';
import 'process.dart';
import 'report.dart';

void main() {
  List<Process> processes = [
    Process(name: 'p1', arrivalTime: 0, burstTime: 5, priority: 1),
    Process(name: 'p2', arrivalTime: 0, burstTime: 3, priority: 2),
    Process(name: 'p3', arrivalTime: 0, burstTime: 8, priority: 1),
    Process(name: 'p4', arrivalTime: 0, burstTime: 6, priority: 3)
  ];

  var scheduler1 = NPPriority();

  scheduler1.newProcesses.addAll(processes);
  scheduler1.scheduleJobs();
  GanttChart ganttChart = scheduler1.scheduleCPU();

  print(ganttChart);
  Report schedulingReport = Report(processes, ganttChart);
  schedulingReport.drawTable();
}
