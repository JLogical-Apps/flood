import 'package:appwrite_core/appwrite_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class ListFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<ValueObjectProperty<List, dynamic, dynamic>> {
  @override
  String getType(ValueObjectProperty<List, dynamic, dynamic> behavior) {
    return {
          List<String>: 'string',
          List<bool>: 'boolean',
          List<int>: 'integer',
          List<double>: 'float',
          List<DateTime>: 'datetime',
          List<Timestamp>: 'datetime',
        }[behavior.getterType] ??
        (throw Exception('Unrecognized list type: [$behavior]'));
  }

  @override
  int? getSize(ValueObjectProperty<List, dynamic, dynamic> behavior) {
    if (behavior.getterType == List<String>) {
      return AppwriteConsts.mediumTextSize;
    }

    return null;
  }

  @override
  bool isArray(ValueObjectProperty<List, dynamic, dynamic> behavior) {
    return true;
  }
}
