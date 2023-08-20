import 'scheduling_algorithms/non_preemptive_schedulers/first_come_first_serve.dart';
import 'scheduling_algorithms/non_preemptive_schedulers/non_preemptive_priority.dart';
import 'scheduling_algorithms/non_preemptive_schedulers/non_preemptive_shortest_job_first.dart';
import 'scheduling_algorithms/preemptive_schedulers/preemptive_shortest_job_first.dart';
import 'gantt_chart/gantt_chart.dart';
import 'process.dart';
import 'report.dart';

void main() {
  List<Process> processes = [
    Process(name: 'p1', arrivalTime: 0, burstTime: 0, priority: 7),
    Process(name: 'p2', arrivalTime: 0, burstTime: 2, priority: 4),
    Process(name: 'p3', arrivalTime: 0, burstTime: 4, priority: 1),
    Process(name: 'p4', arrivalTime: 0, burstTime: 5, priority: 4)
  ];

  var scheduler1 = PSJF();

  scheduler1.newProcesses.addAll(processes);
  GanttChart ganttChart = scheduler1.scheduleJobsAndCPU();

  print(ganttChart);
  Report schedulingReport = Report(processes, ganttChart);
  schedulingReport.drawTable();
}
