import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class NullIfBlankPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<NullIfBlankValueObjectProperty> {
  NullIfBlankPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(NullIfBlankValueObjectProperty behavior) {
    return behavior.property;
  }
}
