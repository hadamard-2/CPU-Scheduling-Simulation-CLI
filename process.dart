import 'gantt_chart.dart';

class Process {
  static int _num = 0;
  String? name;
  int arrivalTime;
  int burstTime;
  int? priority;

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
