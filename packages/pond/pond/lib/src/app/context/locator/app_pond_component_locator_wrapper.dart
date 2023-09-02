import 'package:collection/collection.dart';
import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/app/context/locator/wrapper_app_pond_component_locator_wrapper.dart';

abstract class AppPondComponentLocatorWrapper {
  bool shouldWrap(AppPondComponent component);

  List<AppPondComponent> getSubcomponents(AppPondComponent component);

  static final List<AppPondComponentLocatorWrapper> _wrappers = [
    WrapperAppPondComponentLocatorWrapper(),
  ];

  static AppPondComponentLocatorWrapper? getWrapperOrNull(AppPondComponent component) {
    return _wrappers.firstWhereOrNull((wrapper) => wrapper.shouldWrap(component));
  }

  static List<AppPondComponent> getSubcomponentsOf(AppPondComponent component) {
    return getWrapperOrNull(component)?.getSubcomponents(component) ?? [];
  }
}
