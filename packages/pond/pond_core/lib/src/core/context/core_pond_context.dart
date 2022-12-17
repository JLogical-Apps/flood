import 'package:pond_core/pond_core.dart';
import 'package:pond_core/src/core/context/locator/core_pond_component_locator_wrapper.dart';
import 'package:utils_core/utils_core.dart';

class CorePondContext with IsLocatorWrapper<CorePondComponent> {
  final List<CorePondComponent> components;

  CorePondContext({List<CorePondComponent>? components}) : components = components ?? [];

  @override
  late Locator<CorePondComponent> locator = Locator<CorePondComponent>(
    objects: components,
    onRegistered: (component) async => await component.registerTo(this),
  ).expand((component) => [component] + CorePondComponentLocatorWrapper.getSubcomponentsOf(component));

  Future<void> load() async {
    for (final component in components) {
      await component.load(this);
    }
  }
}
