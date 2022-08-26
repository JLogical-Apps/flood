import 'package:pond/src/pond/context/pond_context.dart';
import 'package:pond_core/pond_core.dart';

class PondPluginCoreRegistry {
  final List<CorePondComponent> coreComponents;

  PondPluginCoreRegistry() : coreComponents = [];

  void onRegister(PondContext pondContext) {
    for (var component in coreComponents) {
      pondContext.corePondContext.register(component);
    }
  }

  void register(CorePondComponent coreComponent) => coreComponents.add(coreComponent);
}
