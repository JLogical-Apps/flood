import 'package:pond/src/pond/context/pond_context.dart';
import 'package:pond/src/pond/context/pond_plugin_core_registry.dart';
import 'package:pond_core/pond_core.dart';

class PondPlugin {
  final PondPluginCoreRegistry coreRegistry;

  PondPlugin() : coreRegistry = PondPluginCoreRegistry();

  void onRegister(PondContext pondContext) {
    coreRegistry.onRegister(pondContext);
  }

  void registerCoreComponent(CorePondComponent corePondComponent) => coreRegistry.register(corePondComponent);
}
