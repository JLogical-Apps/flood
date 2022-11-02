import 'package:pond_core/src/core/component/core_pond_component.dart';

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

mixin IsCorePondModule on IsMultiCorePondComponentWrapper implements CorePondModule {}
