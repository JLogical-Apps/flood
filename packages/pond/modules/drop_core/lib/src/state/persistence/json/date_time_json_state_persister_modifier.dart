import 'package:drop_core/src/state/persistence/json/json_state_persister_modifier.dart';
import 'package:utils_core/utils_core.dart';

class DateTimeJsonStatePersisterModifier extends JsonStatePersisterModifier {
  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    final newData = data.copy();
    newData.replaceWhere((key, value) => value is DateTime, (key, value) => (value as DateTime).toIso8601String());
    return newData;
  }
}
