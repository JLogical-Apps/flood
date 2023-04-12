import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class DefaultPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<DefaultValueObjectProperty> {
  DefaultPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(DefaultValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  dynamic getDefaultValue(DefaultValueObjectProperty behavior) {
    return behavior.getDefaultValue();
  }
}
