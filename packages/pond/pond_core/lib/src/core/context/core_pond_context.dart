import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class CorePondContext with WithLocatorDelegate<CorePondComponent> implements Locator<CorePondComponent> {
  final List<CorePondComponent> components;

  CorePondContext() : components = [];

  @override
  late Locator<CorePondComponent> locator = Locator(
    objects: components,
    onRegistered: (component) => component.registerTo(this),
  );

  Future<void> load() async {
    for (final component in components) {
      await component.load(this);
    }
  }
}
