import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_generator_behavior_wrapper.dart';

class CurrencyPropertyBehaviorWrapper extends WrapperPortGeneratorBehaviorWrapper<CurrencyValueObjectProperty> {
  CurrencyPropertyBehaviorWrapper({required super.wrapperGetter});

  @override
  ValueObjectBehavior unwrapBehavior(CurrencyValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  PortField getPortField(CurrencyValueObjectProperty behavior, PortField sourcePortField) {
    return sourcePortField.cast<int?, int?>().currency(behavior.isCurrency);
  }
}
