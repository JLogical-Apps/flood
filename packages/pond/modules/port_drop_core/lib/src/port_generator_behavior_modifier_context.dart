import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';

class PortGeneratorBehaviorModifierContext {
  final Port<ValueObject> Function() portGetter;

  PortGeneratorBehaviorModifierContext({required this.portGetter});

  Port<ValueObject> get port => portGetter();
}
