import 'package:drop_core/src/record/value_object/time/timestamp.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:utils_core/utils_core.dart';

class DateTimeStatePersisterModifier extends StatePersisterModifier {
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
