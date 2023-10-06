import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class RequiredPropertyBehaviorModifier extends WrapperAppwriteAttributeBehaviorModifier<RequiredValueObjectProperty> {
  RequiredPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(RequiredValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  bool isRequired(RequiredValueObjectProperty behavior) {
    return true;
  }
}
