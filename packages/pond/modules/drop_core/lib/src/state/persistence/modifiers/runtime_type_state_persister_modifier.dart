import 'package:drop_core/src/state/persistence/modifiers/state_persister_modifier.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class RuntimeTypeStatePersisterModifier extends StatePersisterModifier {
  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    var newData = data.copy();
    newData = newData
        .replaceWhereTraversed((key, value) => value is RuntimeType, (key, value) => (value as RuntimeType).name)
        .cast<String, dynamic>();
    return newData;
  }
}
