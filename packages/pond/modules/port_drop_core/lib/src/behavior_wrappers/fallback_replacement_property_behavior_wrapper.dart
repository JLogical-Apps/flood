import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class FallbackReplacementPropertyBehaviorWrapper
    extends WrapperPortGeneratorBehaviorWrapper<FallbackReplacementValueObjectProperty> {
  FallbackReplacementPropertyBehaviorWrapper({required super.wrapperGetter});

  @override
  ValueObjectBehavior unwrapBehavior(FallbackReplacementValueObjectProperty behavior) {
    return behavior.property;
  }
}
