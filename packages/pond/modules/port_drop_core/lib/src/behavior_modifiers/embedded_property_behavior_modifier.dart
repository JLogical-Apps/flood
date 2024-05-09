import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class EmbeddedPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<EmbeddedValueObjectProperty> {
  EmbeddedPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(EmbeddedValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  void Function(ValueObject valueObject)? getValueObjectInstantiator(EmbeddedValueObjectProperty behavior) {
    return behavior.instantiator();
  }
}
