import 'package:utils_core/src/patterns/resolver/resolver.dart';
import 'package:utils_core/src/patterns/resolver/type_resolver.dart';

abstract class Locator<O> implements TypeResolver<O> {
  factory Locator({List<O>? objects}) => _LocatorImpl(objects: objects);

  void register(O object);
}

class _LocatorImpl<O> with WithTypeResolverDelegate<O> implements Locator<O> {
  final List<O> registeredObjects;

  _LocatorImpl({List<O>? objects}) : registeredObjects = objects ?? [];

  @override
  TypeResolver<O> get resolver => Resolver.byType(registeredObjects);

  @override
  void register(O object) {
    registeredObjects.add(object);
  }
}

extension LocatorDefaults<O> on Locator<O> {
  O? locateOrNullRuntime(Type type) {
    return resolveOrNull(type);
  }

  T? locateOrNull<T>() {
    return locateOrNullRuntime(T) as T?;
  }

  O locateRuntime(Type type) {
    return locateOrNullRuntime(type) ?? (throw Exception('Cannot locate [$type]'));
  }

  T locate<T>() {
    return locateRuntime(T) as T;
  }
}

mixin WithLocatorDelegate<O> implements Locator<O> {
  Locator<O> get locator;

  @override
  void register(O object) => locator.register(object);

  @override
  O? resolveOrNull(Type input) => locator.resolveOrNull(input);
}
