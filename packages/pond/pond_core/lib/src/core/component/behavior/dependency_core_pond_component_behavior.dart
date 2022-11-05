import 'package:pond_core/src/core/component/behavior/core_pond_component_behavior.dart';
import 'package:pond_core/src/core/component/core_pond_component.dart';
import 'package:pond_core/src/core/context/core_pond_context.dart';
import 'package:utils_core/utils_core.dart';

/// Asserts that a [T] has been registered. If not, throws an exception.
class DependencyCorePondComponentBehavior<T extends CorePondComponent> with IsCorePondComponentBehavior {
  @override
  void onRegister(CorePondContext context, CorePondComponent component) {
    final existingComponent = context.locateOrNull<T>();
    if (existingComponent == null) {
      throw Exception('$component has a dependency on [$T] but could not be located!');
    }
  }
}
