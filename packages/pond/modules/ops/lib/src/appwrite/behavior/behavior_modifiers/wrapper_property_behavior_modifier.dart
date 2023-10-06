import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class WrapperPropertyBehaviorModifier extends WrapperAppwriteAttributeBehaviorModifier<ValueObjectPropertyWrapper> {
  WrapperPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(ValueObjectPropertyWrapper behavior) {
    return behavior.property;
  }
}
