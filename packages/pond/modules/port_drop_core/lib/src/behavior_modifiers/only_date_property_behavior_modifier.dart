import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier_context.dart';

class OnlyDatePropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<OnlyDateValueObjectProperty> {
  OnlyDatePropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(OnlyDateValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  bool isOnlyDate(OnlyDateValueObjectProperty behavior) {
    return behavior.onlyDate;
  }
}
