import 'package:pond/src/pond/context/pond_plugin.dart';
import 'package:pond_core/pond_core.dart';

class PondContext {
  final List<PondPlugin> plugins;

  final CorePondContext corePondContext;

  PondContext()
      : plugins = [],
        corePondContext = CorePondContext();

  void register(PondPlugin plugin) {
    plugins.add(plugin);
    plugin.onRegister(this);
  }
}
