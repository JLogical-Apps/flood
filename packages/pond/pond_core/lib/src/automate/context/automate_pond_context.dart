import 'package:pond_core/pond_core.dart';
import 'package:pond_core/src/automate/context/locator/automate_pond_component_locator_wrapper.dart';
import 'package:utils_core/utils_core.dart';

class AutomatePondContext with IsLocatorWrapper<AutomatePondComponent> {
  final List<AutomatePondComponent> automateComponents;

  final CorePondContext corePondContext;

  AutomatePondContext({required this.corePondContext}) : automateComponents = [];

  List<AutomateCommand> get commands => automateComponents.expand((component) => component.commands).toList();

  Future<void> load() async {
    await corePondContext.load();

    for (final component in automateComponents) {
      await component.load(this);
    }
  }

  @override
  late final Locator<AutomatePondComponent> locator = Locator<AutomatePondComponent>(
    onRegistered: (component) async {
      automateComponents.add(component);
      component.registerTo(this);
    },
  ).expand((component) => [component] + AutomatePondComponentLocatorWrapper.getSubcomponentsOf(component));

  T? findOrNull<T>() {
    return locateOrNull<T>() ?? corePondContext.locateOrNull<T>();
  }

  T find<T>() {
    return findOrNull<T>() ?? (throw Exception('Could not find [$T]!'));
  }
}
