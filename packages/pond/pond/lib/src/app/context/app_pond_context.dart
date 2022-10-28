import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/app/context/locator/app_pond_component_locator_wrapper.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AppPondContext with WithLocatorDelegate<AppPondComponent> {
  final List<AppPondComponent> appComponents;

  final CorePondContext corePondContext;

  AppPondContext({required this.corePondContext, List<AppPondComponent>? appComponents})
      : appComponents = appComponents ?? [];

  Future<void> load() async {
    await corePondContext.load();

    for (final component in appComponents) {
      await component.load(this);
    }
  }

  @override
  Locator<AppPondComponent> get locator => Locator<AppPondComponent>(
        objects: appComponents,
        onRegistered: (component) => component.registerTo(this),
      ).expand((component) => [component] + AppPondComponentLocatorWrapper.getSubcomponentsOf(component));
}
