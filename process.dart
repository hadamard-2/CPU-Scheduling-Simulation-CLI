import 'gantt_chart/gantt_chart.dart';

class Process {
  static int _num = 0;
  String? name;
  int arrivalTime;
  int burstTime;
  // only used for priority scheduling
  int? priority;
  // only used for preemptive scheduling
  // I only initialized it because I was forced to by Dart's null safety
  int remainingTime = 0;

  // to be read from gantt chart
  int? serviceTime;
  int? completionTime;

  // to be computed
  int? turnAroundTime;
  int? waitingTime;
  int? responseTime;

  Process(
      {String? name,
      this.arrivalTime = 0,
      required this.burstTime,
      this.priority}) {
    this.name = name ?? 'p${_num++}';
    this.remainingTime = burstTime;
  }

  void readGanttChart(GanttChart ganttChart) {
    serviceTime = ganttChart.getProcessServiceTime(this);
    completionTime = ganttChart.getProcessCompletionTime(this);
  }

  void computeTurnAroundTime() {
    turnAroundTime = completionTime! - arrivalTime;
  }

  // I'm not sure about whether or not this implementation applies to all sorts
  // of algorithms
  void computeWaitingTime() {
    // turn around time - burst time
    waitingTime = turnAroundTime! - burstTime;
  }

  void computeResponseTime() {
    responseTime = serviceTime! - arrivalTime;
  }
}
