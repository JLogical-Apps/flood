import 'package:drop_core/drop_core.dart';
import 'package:port_drop_core/port_drop_core.dart';

class PortGeneratorOverrideContext {
  final ValueObject initialValueObject;
  final CorePortDropComponent corePortDropComponent;

  const PortGeneratorOverrideContext({
    required this.initialValueObject,
    required this.corePortDropComponent,
  });
}
