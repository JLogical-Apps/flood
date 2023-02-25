import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortGeneratorBehaviorWrapper<T extends ValueObjectBehavior> with IsTypedWrapper<T, ValueObjectBehavior> {
  Map<String, PortValue> getPortValueByName(ValueObjectBehavior behavior);
}
