import 'package:pond_core/pond_core.dart';

class CorePondContext {
  final List<CorePondComponent> components;

  CorePondContext() : components = [];

  void register(CorePondComponent component) {
    components.add(component);
  }
}
