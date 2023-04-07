import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:utils_core/utils_core.dart';

class FallbackReplacementPropertyBehaviorModifier
    extends WrapperPortGeneratorBehaviorModifier<FallbackReplacementValueObjectProperty> {
  FallbackReplacementPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackReplacementValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(FallbackReplacementValueObjectProperty behavior, PortField sourcePortField) {
    return sourcePortField.withDynamicHint(() => guard<String?>(() => behavior.fallbackReplacement()?.toString()));
  }
}
