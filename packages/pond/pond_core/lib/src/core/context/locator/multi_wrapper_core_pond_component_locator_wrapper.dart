import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/locator/core_pond_component_locator_wrapper.dart';

class MultiWrapperCorePondComponentLocatorWrapper extends CorePondComponentLocatorWrapper {
  @override
  bool shouldWrap(CorePondComponent component) {
    return component is MultiCorePondComponentWrapper;
  }

  @override
  List<CorePondComponent> getSubcomponents(CorePondComponent component) {
    final wrapper = component as MultiCorePondComponentWrapper;
    return wrapper.corePondComponents.expand(CorePondComponentLocatorWrapper.getSubcomponentsOf).toList();
  }
}
