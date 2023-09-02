import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';
import 'package:pond_core/src/core/context/locator/wrapper_core_pond_component_locator_wrapper.dart';

abstract class CorePondComponentLocatorWrapper {
  bool shouldWrap(CorePondComponent component);

  List<CorePondComponent> getSubcomponents(CorePondComponent component, CorePondContext context);

  static final List<CorePondComponentLocatorWrapper> _wrappers = [
    WrapperCorePondComponentLocatorWrapper(),
  ];

  static CorePondComponentLocatorWrapper? getWrapperOrNull(CorePondComponent component) {
    return _wrappers.firstWhereOrNull((wrapper) => wrapper.shouldWrap(component));
  }

  static List<CorePondComponent> getSubcomponentsOf(CorePondComponent component, CorePondContext context) {
    return getWrapperOrNull(component)?.getSubcomponents(component, context) ?? [];
  }
}
