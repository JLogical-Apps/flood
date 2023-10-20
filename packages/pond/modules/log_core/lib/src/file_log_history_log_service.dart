import 'package:collection/collection.dart';
import 'package:log_core/src/log_history.dart';
import 'package:log_core/src/logger_service.dart';
import 'package:persistence_core/persistence_core.dart';

class FileLogHistoryLoggerService with IsLoggerServiceWrapper {
  @override
  late final LoggerService loggerService;

  final CrossDirectory logDirectory;

  late final DateTime createdTime = DateTime.now();
  late final CrossFile currentLogFile = logDirectory - '$createdTime.log';

  String _log = '';

  FileLogHistoryLoggerService({required LoggerService loggerService, required this.logDirectory}) {
    this.loggerService = loggerService.withListener(
      onLog: (message) async {
        await currentLogFile.ensureCreated();
        _log += '$message\n---\n';
        await currentLogFile.writeAsString(_log);
      },
      onLogWarning: (message) async {
        await currentLogFile.ensureCreated();
        _log += '[WARNING] $message\n---\n';
        await currentLogFile.writeAsString(_log);
      },
      onLogError: (error, stackTrace) async {
        await currentLogFile.ensureCreated();
        _log += '[ERROR] $error\n$stackTrace\n---\n';
        await currentLogFile.writeAsString(_log);
      },
    );
  }

  @override
  Future<List<LogHistory>> getLogHistories() async {
    final elements = await logDirectory.listOrNull() ?? [];
    return elements
        .whereType<CrossFile>()
        .sorted((a, b) => b.path.compareTo(a.path))
        .map((crossFile) => LogHistory.static.crossFile(crossFile))
        .toList();
  }
}
