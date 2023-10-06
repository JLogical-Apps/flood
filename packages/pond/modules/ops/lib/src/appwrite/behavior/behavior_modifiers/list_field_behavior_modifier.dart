import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';
import 'package:ops/src/appwrite/util/appwrite_consts.dart';

class ListFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<List>> {
  @override
  String getType(SimpleValueObjectProperty<List> behavior) {
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
  int? getSize(SimpleValueObjectProperty<List> behavior) {
    if (behavior.getterType == List<String>) {
      return AppwriteConsts.mediumTextSize;
    }

    return null;
  }

  @override
  bool isArray(SimpleValueObjectProperty<List> behavior) {
    return true;
  }
}
