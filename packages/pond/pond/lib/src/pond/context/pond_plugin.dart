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

/*
class WithDebugPondPluginWrapper extends PondPluginWrapper {
  void onRegister() {
    final name = PluginNameResolver().resolve(plugin);
    print('Registering [$name] plugin');
  }
}

class RuntimeTypePluginNameResolver extends PluginNameResolver {
  shouldWrap(T value) {
    return value.runtimeType != PondPlugin;
  }

  String getName(T value) {
    return value.runtimeType;
  }
}

class InterfacePluginNameResolver extends PluginNameResolver {
  shouldWrap(T value) {
    return value instanceof HasPluginName;
  }

  String getName(T value) {
    return (value as HasPluginName).name;
  }
}
 */
