import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

abstract class CorePondModule with IsMultiCorePondComponentWrapper {
  factory CorePondModule({required List<CorePondComponent> corePondComponents}) {
    return _CorePondModuleImpl(corePondComponents: corePondComponents);
  }
}

class _CorePondModuleImpl with IsMultiCorePondComponentWrapper, IsCorePondModule {
  @override
  final List<CorePondComponent> corePondComponents;

  _CorePondModuleImpl({required this.corePondComponents});
}

mixin IsCorePondModule implements CorePondModule {
  @override
  Future onLoad(CorePondContext context) async {}

  @override
  void onRegister(CorePondContext context) {}
}

abstract class CorePondModuleWrapper with IsCorePondModule {
  CorePondModule get corePondModule;

  @override
  List<CorePondComponent> get corePondComponents => corePondModule.corePondComponents;
}

mixin IsCorePondModuleWrapper implements CorePondModuleWrapper {
  @override
  List<CorePondComponent> get corePondComponents => corePondModule.corePondComponents;

  @override
  Future onLoad(CorePondContext context) async {}

  @override
  void onRegister(CorePondContext context) {}
}
