import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/core_port_drop_component.dart';

class PortGeneratorBehaviorModifierContext {
  final CorePortDropComponent corePortDropComponent;
  final CorePondContext corePondContext;
  final ValueObject originalValueObject;
  final ValueObjectBehavior originalBehavior;
  final Port<ValueObject> Function() portGetter;

  PortGeneratorBehaviorModifierContext({
    required this.corePortDropComponent,
    required this.corePondContext,
    required this.originalValueObject,
    required this.originalBehavior,
    required this.portGetter,
  });

  Port<ValueObject> get port => portGetter();
}
