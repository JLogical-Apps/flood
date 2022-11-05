import 'package:utils_core/src/patterns/locator/expand_locator.dart';
import 'package:utils_core/src/patterns/resolver/resolver.dart';
import 'package:utils_core/src/patterns/resolver/type_resolver.dart';

abstract class Locator<O> implements TypeResolver<O> {
  factory Locator({List<O>? objects, void Function(O object)? onRegistered}) => _LocatorImpl(
        objects: objects,
        onRegistered: onRegistered,
      );

  void register(O object);
}

class _LocatorImpl<O> with WithTypeResolverDelegate<O> implements Locator<O> {
  final List<O> registeredObjects;
  final void Function(O object)? onRegistered;
  final Type Function(O object)? typeMapper;

  _LocatorImpl({List<O>? objects, this.onRegistered, this.typeMapper}) : registeredObjects = objects ?? [];

  @override
  TypeResolver<O> get resolver => Resolver.byType(registeredObjects);

  @override
  void register(O object) {
    registeredObjects.add(object);
    onRegistered?.call(object);
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

  O locateOrRegisterRuntime(Type type, O Function() itemGetter) {
    final registered = locateOrNullRuntime(type);
    if (registered != null) {
      return registered;
    }

    final newItem = itemGetter();
    register(newItem);
    return newItem;
  }

  T locateOrRegister<T extends O>(T Function() itemGetter) {
    final registered = locateOrNull<T>();
    if (registered != null) {
      return registered;
    }

    final newItem = itemGetter();
    register(newItem);
    return newItem;
  }

  Locator<O> expand(List<O> Function(O object) expander) {
    return ExpandLocator(locator: this, expander: expander);
  }
}

mixin WithLocatorDelegate<O> implements Locator<O> {
  Locator<O> get locator;

  @override
  void register(O object) => locator.register(object);

  @override
  O? resolveOrNull(Type input) => locator.resolveOrNull(input);
}
