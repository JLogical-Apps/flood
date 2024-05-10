import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class MapperPropertyBehaviorModifier extends WrapperPortGeneratorBehaviorModifier<MapperValueObjectProperty> {
  MapperPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(MapperValueObjectProperty behavior) {
    return behavior.property;
  }
}
