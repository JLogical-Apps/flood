import 'package:drop_core/src/state/persistence/json/json_state_persister_modifier.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class RuntimeTypeJsonStatePersisterModifier extends JsonStatePersisterModifier {
  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData
        .replaceWhereTraversed((key, value) => value is RuntimeType, (key, value) => (value as RuntimeType).name)
        .cast<String, dynamic>();
    return newData;
  }
}
