import 'bar.dart';
import '../process.dart';

class GanttChart {
  List<Bar> _processBars = new List<Bar>.empty(growable: true);

  void addProcessBar(Bar bar) {
    _processBars.add(bar);
  }

  int getProcessServiceTime(Process process) {
    int barIndex = _processBars.indexWhere((bar) => bar.process == process);
    if (barIndex != -1) {
      return _processBars[barIndex].timeInterval.start;
    }
    return -1;
  }

  int getProcessCompletionTime(Process process) {
    int barIndex = _processBars.lastIndexWhere((bar) => bar.process == process);
    if (barIndex != -1) {
      return _processBars[barIndex].timeInterval.end;
    }
    return -1;
  }

  @override
  String toString() {
    String outputStr = "";
    for (Bar processBar in _processBars) {
      outputStr +=
          '${processBar.timeInterval.start}-${processBar.timeInterval.end}: ${processBar.process.name}\n';
    }
    return outputStr;
  }
}
