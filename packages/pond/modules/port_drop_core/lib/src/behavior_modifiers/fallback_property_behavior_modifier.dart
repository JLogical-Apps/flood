import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class FallbackPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<FallbackValueObjectProperty> {
  FallbackPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackValueObjectProperty behavior) {
    return behavior.property;
  }
}
