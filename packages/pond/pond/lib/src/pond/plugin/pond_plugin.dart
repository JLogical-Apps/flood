import 'package:pond/src/pond/context/pond_context.dart';
import 'package:pond/src/pond/plugin/pond_plugin_core_registry.dart';
import 'package:pond_core/pond_core.dart';

abstract class PondPlugin {
  String get name;

  PondPluginCoreRegistry get coreRegistry;

  factory PondPlugin({required String name, PondPluginCoreRegistry? pondPluginCoreRegistry}) =>
      _PondPluginImpl(name: name, coreRegistry: pondPluginCoreRegistry ?? PondPluginCoreRegistry());
}

class _PondPluginImpl implements PondPlugin {
  @override
  final String name;

  @override
  final PondPluginCoreRegistry coreRegistry;

  _PondPluginImpl({required this.name, required this.coreRegistry});
}

extension PondPluginExtensions on PondPlugin {
  void onRegister(PondContext pondContext) {
    coreRegistry.onRegister(pondContext);
  }

  void registerCoreComponent(CorePondComponent corePondComponent) {
    coreRegistry.register(corePondComponent);
  }
}
