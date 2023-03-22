import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortGeneratorBehaviorWrapper<T extends ValueObjectBehavior> with IsTypedWrapper<T, ValueObjectBehavior> {
  Map<String, PortField> getPortFieldByName(ValueObjectBehavior behavior);
}

abstract class WrapperPortGeneratorBehaviorWrapper<T extends ValueObjectBehavior>
    extends PortGeneratorBehaviorWrapper<T> {
  final PortGeneratorBehaviorWrapper? Function(ValueObjectBehavior behavior) wrapperGetter;

  WrapperPortGeneratorBehaviorWrapper({required this.wrapperGetter});

  ValueObjectBehavior unwrapBehavior(T behavior);

  PortField getPortField(PortField sourcePortField) {
    return sourcePortField;
  }

  @override
  Map<String, PortField> getPortFieldByName(ValueObjectBehavior behavior) {
    final unwrappedBehavior = unwrapBehavior(behavior as T);
    final subWrapper = wrapperGetter(unwrappedBehavior);
    if (subWrapper == null) {
      return {};
    }

    final subPortFieldByName = subWrapper.getPortFieldByName(unwrappedBehavior);
    return subPortFieldByName.mapValues((name, portField) => getPortField(portField));
  }
}
