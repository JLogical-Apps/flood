import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class HiddenPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<HiddenValueObjectProperty> {
  HiddenPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(HiddenValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField? getPortField(HiddenValueObjectProperty behavior, PortField sourcePortField) {
    return behavior.isHidden ? null : sourcePortField;
  }
}
