import 'package:port_core/port_core.dart';

class PortGeneratorBehaviorModifierContext {
  final Port Function() portGetter;

  PortGeneratorBehaviorModifierContext({required this.portGetter});

  Port get port => portGetter();
}
