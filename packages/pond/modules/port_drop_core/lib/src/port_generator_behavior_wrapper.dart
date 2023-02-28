import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortGeneratorBehaviorWrapper<T extends ValueObjectBehavior> with IsTypedWrapper<T, ValueObjectBehavior> {
  Map<String, PortValue> getPortValueByName(ValueObjectBehavior behavior);
}

abstract class WrapperPortGeneratorBehaviorWrapper<T extends ValueObjectBehavior>
    extends PortGeneratorBehaviorWrapper<T> {
  final PortGeneratorBehaviorWrapper? Function(ValueObjectBehavior behavior) wrapperGetter;

  WrapperPortGeneratorBehaviorWrapper({required this.wrapperGetter});

  ValueObjectBehavior unwrapBehavior(T behavior);

  PortValue getPortValue(PortValue sourcePortValue) {
    return sourcePortValue;
  }

  @override
  Map<String, PortValue> getPortValueByName(ValueObjectBehavior behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior as T);
    final subWrapper = wrapperGetter(unwrappedBehavior);
    if (subWrapper == null) {
      return {};
    }

    final subPortValueByName = subWrapper.getPortValueByName(unwrappedBehavior);
    return subPortValueByName.mapValues((name, portValue) => getPortValue(portValue));
  }
}
