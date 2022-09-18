import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class CorePondContext with WithTypedResolver<CorePondComponent> {
  final List<CorePondComponent> components;

  CorePondContext() : components = [];

  @override
  late TypeResolver<CorePondComponent> typeResolver = Resolver.byType(components);

  void register(CorePondComponent component) {
    components.add(component);
  }
}
