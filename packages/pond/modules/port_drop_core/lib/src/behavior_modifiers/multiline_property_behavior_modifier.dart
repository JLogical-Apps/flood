import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class MultilinePropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<MultilineValueObjectProperty> {
  MultilinePropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(MultilineValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(MultilineValueObjectProperty behavior, PortField sourcePortField) {
    return sourcePortField.cast<String, String>().multiline(behavior.isMultiline);
  }
}
