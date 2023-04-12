import 'package:drop_core/drop_core.dart';
import 'package:port_core/port_core.dart';
import 'package:port_drop_core/src/port_drop_core_component.dart';

class PortGeneratorBehaviorModifierContext {
  final PortDropCoreComponent portDropCoreComponent;
  final ValueObject originalValueObject;
  final ValueObjectBehavior originalBehavior;
  final Port<ValueObject> Function() portGetter;

  PortGeneratorBehaviorModifierContext({
    required this.portDropCoreComponent,
    required this.originalValueObject,
    required this.originalBehavior,
    required this.portGetter,
  });

  Port<ValueObject> get port => portGetter();
}
