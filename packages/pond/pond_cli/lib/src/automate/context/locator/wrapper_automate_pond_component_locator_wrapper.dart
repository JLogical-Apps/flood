import 'package:pond_cli/src/automate/component/automate_pond_component.dart';
import 'package:pond_cli/src/automate/context/locator/automate_pond_component_locator_wrapper.dart';

class WrapperAutomatePondComponentLocatorWrapper extends AutomatePondComponentLocatorWrapper {
  @override
  bool shouldWrap(AutomatePondComponent component) {
    return component is AutomatePondComponentWrapper;
  }

  @override
  List<AutomatePondComponent> getSubcomponents(AutomatePondComponent component) {
    final wrapper = component as AutomatePondComponentWrapper;
    return [wrapper.automatePondComponent];
  }
}
