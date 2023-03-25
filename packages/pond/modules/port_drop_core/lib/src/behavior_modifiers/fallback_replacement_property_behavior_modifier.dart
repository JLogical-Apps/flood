import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class FallbackReplacementPropertyBehaviorModifier
    extends WrapperPortGeneratorBehaviorModifier<FallbackReplacementValueObjectProperty> {
  FallbackReplacementPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackReplacementValueObjectProperty behavior) {
    return behavior.property;
  }
}
