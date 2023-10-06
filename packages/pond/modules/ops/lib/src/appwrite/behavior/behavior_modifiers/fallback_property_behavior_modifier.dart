import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class FallbackPropertyBehaviorModifier extends WrapperAppwriteAttributeBehaviorModifier<FallbackValueObjectProperty> {
  FallbackPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackValueObjectProperty behavior) {
    return behavior.property;
  }
}
