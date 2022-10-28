import 'package:pond/pond.dart';
import 'package:pond/src/app/context/locator/app_pond_component_locator_wrapper.dart';

class WrapperAppPondComponentLocatorWrapper extends AppPondComponentLocatorWrapper {
  @override
  bool shouldWrap(AppPondComponent component) {
    return component is AppPondComponentWrapper;
  }

  @override
  List<AppPondComponent> getSubcomponents(AppPondComponent component) {
    final wrapper = component as AppPondComponentWrapper;
    return [wrapper.appPondComponent];
  }
}
