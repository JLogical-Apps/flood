import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

abstract class CorePondModule with IsCorePondComponent implements MultiCorePondComponentWrapper {
  factory CorePondModule({required List<CorePondComponent> corePondComponents}) {
    return _CorePondModuleImpl(corePondComponents: corePondComponents);
  }
}

class _CorePondModuleImpl with IsCorePondModule {
  @override
  final List<CorePondComponent> corePondComponents;

  _CorePondModuleImpl({required this.corePondComponents});
}

mixin IsCorePondModule implements CorePondModule {
  @override
  void onRegister(CorePondContext context) {}

  @override
  Future onLoad(CorePondContext context) async {}
}
