import 'package:log_core/src/log_history.dart';
import 'package:path/path.dart';
import 'package:persistence_core/persistence_core.dart';

class CrossFileLogHistory with IsLogHistory {
  final CrossFile file;

  CrossFileLogHistory({required this.file});

  @override
  Future<DateTime> getTimeCreated() async {
    final name = basenameWithoutExtension(file.path);
    return DateTime.parse(name);
  }

  @override
  Future<List<String>> getLogs() async {
    final rawLogs = await file.readAsString();
    return rawLogs.split('\n---\n');
  }
}
