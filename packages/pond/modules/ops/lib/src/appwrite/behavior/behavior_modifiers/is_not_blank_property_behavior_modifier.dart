import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class IsNotBlankPropertyBehaviorModifier
    extends WrapperAppwriteAttributeBehaviorModifier<IsNotBlankValueObjectProperty> {
  IsNotBlankPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(IsNotBlankValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  bool isRequired(IsNotBlankValueObjectProperty behavior) {
    return true;
  }
}
