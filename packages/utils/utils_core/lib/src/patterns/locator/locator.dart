import 'package:utils_core/src/patterns/resolver/resolver.dart';
import 'package:utils_core/src/patterns/resolver/type_resolver.dart';

class Locator<O> {
  final List<O> registeredObjects;

  Locator({List<O>? objects}) : registeredObjects = objects ?? [];

  late TypeResolver<O> typeResolver = Resolver.byType(registeredObjects);

  void register(O object) {
    registeredObjects.add(object);
  }

  O? locateOrNullRuntime(Type type) {
    return typeResolver.resolveOrNull(type);
  }

  O? locateOrNull<T>() {
    return locateOrNullRuntime(T);
  }

  O locateRuntime(Type type) {
    return locateOrNullRuntime(type) ?? (throw Exception('Cannot locate [$type]'));
  }

  O locate<T>() {
    return locateRuntime(T);
  }
}

mixin WithLocatorDelegate<O> implements Locator<O> {
  Locator<O> get locator;
}
