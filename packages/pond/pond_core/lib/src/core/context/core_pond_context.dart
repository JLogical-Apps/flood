import 'package:pond_core/pond_core.dart';
import 'package:pond_core/src/core/context/locator/core_pond_component_locator_wrapper.dart';
import 'package:utils_core/utils_core.dart';

class CorePondContext with IsLocatorWrapper<CorePondComponent> {
  final List<CorePondComponent> components;

  CorePondContext() : components = [];

  @override
  late Locator<CorePondComponent> locator = Locator<CorePondComponent>(onRegistered: (component) async {
    components.add(component);
    await component.registerTo(this);
  }).expand((component) => [component] + CorePondComponentLocatorWrapper.getSubcomponentsOf(component, this));

  Future<void> load() async {
    for (final component in components) {
      await component.load(this);
    }
  }

  Future<void> reset() async {
    for (final component in components) {
      await component.reset(this);
    }
  }
}
