import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class FallbackPropertyBehaviorWrapper extends WrapperPortGeneratorBehaviorWrapper<FallbackValueObjectProperty> {
  FallbackPropertyBehaviorWrapper({required super.wrapperGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackValueObjectProperty behavior) {
    return behavior.property;
  }
}
