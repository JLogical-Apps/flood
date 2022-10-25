import 'package:pond_core/pond_core.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';

abstract class CorePondComponent {
  void onRegister(CorePondContext context) {}

  Future onLoad(CorePondContext context) async {}
}

extension CorePondComponentExtension on CorePondComponent {
  void registerTo(CorePondContext context) {
    onRegister(context);
  }

  Future load(CorePondContext context) {
    return onLoad(context);
  }
}
