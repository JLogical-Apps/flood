import 'package:log_core/src/history/file_log_history.dart';
import 'package:persistence_core/persistence_core.dart';

abstract class LogHistory {
  Future<DateTime> getTimeCreated();

  Future<List<String>> getLogs();

  factory LogHistory({required List<String> logs, required DateTime timeCreated}) =>
      _LogHistoryImpl(timeCreated: timeCreated, logs: logs);

  static final LogHistoryStatic static = LogHistoryStatic();
}

class LogHistoryStatic {
  LogHistory crossFile(CrossFile file) => CrossFileLogHistory(file: file);
}

mixin IsLogHistory implements LogHistory {}

class _LogHistoryImpl with IsLogHistory {
  final DateTime timeCreated;
  final List<String> logs;

  _LogHistoryImpl({required this.timeCreated, required this.logs});

  @override
  Future<DateTime> getTimeCreated() async {
    return timeCreated;
  }

  @override
  Future<List<String>> getLogs() async {
    return logs;
  }
}
