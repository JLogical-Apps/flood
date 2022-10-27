import 'package:collection/collection.dart';
import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/locator/wrapper_core_pond_component_locator_wrapper.dart';

abstract class CorePondComponentLocatorWrapper {
  bool shouldWrap(CorePondComponent component);

  List<CorePondComponent> getSubcomponents(CorePondComponent component);

  static final List<CorePondComponentLocatorWrapper> _wrappers = [
    WrapperCorePondComponentLocatorWrapper(),
  ];

  static CorePondComponentLocatorWrapper? getWrapperOrNull(CorePondComponent component) {
    return _wrappers.firstWhereOrNull((wrapper) => wrapper.shouldWrap(component));
  }

  static List<CorePondComponent> getSubcomponentsOf(CorePondComponent component) {
    return getWrapperOrNull(component)?.getSubcomponents(component) ?? [component];
  }
}
