import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/app/context/locator/app_pond_component_locator_wrapper.dart';
import 'package:pond/src/app/page/app_page.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AppPondContext with IsLocatorWrapper<AppPondComponent> {
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

  List<AppPage> getPages() {
    return appComponents.expand((component) => component.pages).toList();
  }

  @override
  Locator<AppPondComponent> get locator => Locator<AppPondComponent>(
        objects: appComponents,
        onRegistered: (component) => component.registerTo(this),
      ).expand((component) => [component] + AppPondComponentLocatorWrapper.getSubcomponentsOf(component));

  T? findOrNull<T>() {
    return locateOrNull<T>() ?? corePondContext.locateOrNull<T>();
  }

  T find<T>() {
    return findOrNull<T>() ?? (throw Exception('Could not find [$T]!'));
  }
}
