import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/state/persistence/json/json_state_persister_modifier.dart';
import 'package:utils_core/utils_core.dart';

class DateTimeJsonStatePersisterModifier extends JsonStatePersisterModifier {
  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData
        .replaceWhereTraversed((key, value) => value is DateTime, (key, value) => (value as DateTime).toIso8601String())
        .cast<String, dynamic>();
    newData = newData
        .replaceWhereTraversed(
          (key, value) => value is Timestamp,
          (key, value) => (value as Timestamp).time.toIso8601String(),
        )
        .cast<String, dynamic>();
    return newData;
  }
}
