import 'package:collection/collection.dart';
import 'package:utils_core/src/patterns/resolver/resolver.dart';

class TypeResolver<O> implements Resolver<Type, O> {
  final List<O> _resolvableObjects;

  const TypeResolver({required List<O> resolvableObjects}) : _resolvableObjects = resolvableObjects;

  @override
  O? resolveOrNull(Type input) {
    return _resolvableObjects.firstWhereOrNull((object) => object.runtimeType == input);
  }
}

extension TypeResolverExtensions<O> on TypeResolver<O> {
  O? resolveTypeOrNull<T>() {
    return resolveOrNull(T);
  }

  O resolveType<T>() {
    return resolve(T);
  }
}

mixin WithTypeResolverDelegate<O> implements TypeResolver<O> {
  TypeResolver<O> get resolver;

  @override
  O? resolveOrNull(Type input) => resolver.resolveOrNull(input);
}
