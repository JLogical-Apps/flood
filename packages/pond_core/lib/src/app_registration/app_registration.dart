import 'package:pond_core/pond_core.dart';

class AppRegistration {
  final List<AppComponent> components;

  AppRegistration() : components = [];

  void register(AppComponent component) {
    components.add(component);
  }
}
