import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';
import 'package:pond_core/src/core/context/locator/core_pond_component_locator_wrapper.dart';

class WrapperCorePondComponentLocatorWrapper extends CorePondComponentLocatorWrapper {
  @override
  bool shouldWrap(CorePondComponent component) {
    return component is CorePondComponentWrapper;
  }

  @override
  List<CorePondComponent> getSubcomponents(CorePondComponent component, CorePondContext context) {
    component.context = context;
    final wrapper = component as CorePondComponentWrapper;
    final wrappedComponent = wrapper.corePondComponent;
    return CorePondComponentLocatorWrapper.getWrapperOrNull(wrappedComponent)
            ?.getSubcomponents(wrappedComponent, context) ??
        [wrappedComponent];
  }
}
