import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class FallbackReplacementPropertyBehaviorModifier
    extends WrapperAppwriteAttributeBehaviorModifier<FallbackReplacementValueObjectProperty> {
  FallbackReplacementPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackReplacementValueObjectProperty behavior) {
    return behavior.property;
  }
}
