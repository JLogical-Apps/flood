import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_modifier.dart';

class AsyncFallbackPropertyBehaviorModifier
    extends WrapperPortGeneratorBehaviorModifier<AsyncFallbackValueObjectProperty> {
  AsyncFallbackPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(AsyncFallbackValueObjectProperty behavior) {
    return behavior.property;
  }
}
