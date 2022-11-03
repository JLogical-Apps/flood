import 'package:drop_core/src/drop_core_component.dart';
import 'package:pond_core/pond_core.dart';

class DropCoreModule with IsCorePondModuleWrapper {
  @override
  CorePondModule get corePondModule => CorePondModule(corePondComponents: [DropCoreComponent()]);
}
