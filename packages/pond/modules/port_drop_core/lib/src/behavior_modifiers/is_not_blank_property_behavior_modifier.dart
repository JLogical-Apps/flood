import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class IsNotBlankPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<IsNotBlankValueObjectProperty> {
  IsNotBlankPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(IsNotBlankValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(IsNotBlankValueObjectProperty behavior, PortField sourcePortField) {
    return sourcePortField.cast<String, String>().isNotBlank();
  }
}
