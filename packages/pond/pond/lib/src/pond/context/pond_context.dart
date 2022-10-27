import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/app/context/app_pond_context.dart';
import 'package:pond/src/pond/plugin/pond_plugin.dart';
import 'package:pond_core/pond_core.dart';

class PondContext {
  final List<PondPlugin> plugins;

  final List<CorePondComponent> coreComponents;
  final List<AppPondComponent> appComponents;

  PondContext()
      : plugins = [],
        coreComponents = [],
        appComponents = [];

  CorePondContext get corePondContext => CorePondContext(components: coreComponents);

  AppPondContext get appPondContext => AppPondContext(corePondContext: corePondContext, appComponents: appComponents);

  void register(PondPlugin plugin) {
    plugins.add(plugin);
    plugin.onRegister(this);
  }

  void registerCoreComponent(CorePondComponent component) {
    coreComponents.add(component);
  }
}
