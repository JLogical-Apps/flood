import 'package:collection/collection.dart';
import 'package:pond_cli/src/automate/component/automate_pond_component.dart';
import 'package:pond_cli/src/automate/context/locator/wrapper_automate_pond_component_locator_wrapper.dart';

abstract class AutomatePondComponentLocatorWrapper {
  bool shouldWrap(AutomatePondComponent component);

  List<AutomatePondComponent> getSubcomponents(AutomatePondComponent component);

  static final List<AutomatePondComponentLocatorWrapper> _wrappers = [
    WrapperAutomatePondComponentLocatorWrapper(),
  ];

  static AutomatePondComponentLocatorWrapper? getWrapperOrNull(AutomatePondComponent component) {
    return _wrappers.firstWhereOrNull((wrapper) => wrapper.shouldWrap(component));
  }

  static List<AutomatePondComponent> getSubcomponentsOf(AutomatePondComponent component) {
    return getWrapperOrNull(component)?.getSubcomponents(component) ?? [component];
  }
}
