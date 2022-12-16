import 'dart:async';

import 'package:utils_core/src/patterns/locator/expand_locator.dart';
import 'package:utils_core/src/patterns/resolver/resolver.dart';
import 'package:utils_core/src/patterns/resolver/type_resolver.dart';

abstract class Locator<O> implements TypeResolver<O> {
  factory Locator({List<O>? objects, void Function(O object)? onRegistered}) => _LocatorImpl(
        objects: objects,
        onRegistered: onRegistered,
      );

  FutureOr<void> onRegister(O object);
}

class _LocatorImpl<O> with WithTypeResolverDelegate<O> implements Locator<O> {
  final List<O> registeredObjects;
  final FutureOr<void> Function(O object)? onRegistered;
  final Type Function(O object)? typeMapper;

  _LocatorImpl({List<O>? objects, this.onRegistered, this.typeMapper}) : registeredObjects = objects ?? [];

  @override
  TypeResolver<O> get resolver => Resolver.byType(registeredObjects);

  @override
  Future onRegister(O object) async {
    registeredObjects.add(object);
    await onRegistered?.call(object);
  }
}

extension LocatorDefaults<O> on Locator<O> {
  Future<void> register(O object) async {
    return await onRegister(object);
  }

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

  Future<O> locateOrRegisterRuntime(Type type, O Function() itemGetter) async {
    final registered = locateOrNullRuntime(type);
    if (registered != null) {
      return registered;
    }

    final newItem = itemGetter();
    await register(newItem);
    return newItem;
  }

  Future<T> locateOrRegister<T extends O>(T Function() itemGetter) async {
    final registered = locateOrNull<T>();
    if (registered != null) {
      return registered;
    }

    final newItem = itemGetter();
    await register(newItem);
    return newItem;
  }

  Locator<O> expand(List<O> Function(O object) expander) {
    return ExpandLocator(locator: this, expander: expander);
  }
}

mixin IsLocatorWrapper<O> implements Locator<O> {
  Locator<O> get locator;

  @override
  FutureOr<void> onRegister(O object) => locator.register(object);

  @override
  O? resolveOrNull(Type input) => locator.resolveOrNull(input);
}
