import 'package:drop_core/src/record/value_object/time/timestamp.dart';
import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:utils_core/utils_core.dart';

class TimestampStatePersisterModifier extends StatePersisterModifier {
  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData
        .replaceWhereTraversed(
          (key, value) => value is Timestamp,
          (key, value) => (value as Timestamp).time,
        )
        .cast<String, dynamic>();
    return newData;
  }
}
