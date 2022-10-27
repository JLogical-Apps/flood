import 'package:pond/src/app/component/app_pond_component.dart';
import 'package:pond/src/pond/context/pond_context.dart';

class PondPluginAppRegistry {
  final List<AppPondComponent> appComponents;

  PondPluginAppRegistry() : appComponents = [];

  void onRegister(PondContext pondContext) {
    for (var component in appComponents) {
      pondContext.appComponents.add(component);
    }
  }

  void register(AppPondComponent component) => appComponents.add(component);
}
