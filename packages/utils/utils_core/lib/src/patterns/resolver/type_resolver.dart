import 'package:collection/collection.dart';
import 'package:utils_core/src/patterns/resolver/resolver.dart';

class TypeResolver<O> implements Resolver<Type, O> {
  final List<O> objects;

  const TypeResolver({required this.objects});

  @override
  O? resolveOrNull(Type input) {
    return objects.firstWhereOrNull((object) => object.runtimeType == input);
  }
}

mixin WithTypedResolver<O> {
  TypeResolver<O> get typeResolver;

  O? resolveOrNullRuntime(Type type) {
    return typeResolver.resolveOrNull(type);
  }

  O? resolveOrNull<T>() {
    return resolveOrNullRuntime(T);
  }

  O resolveRuntime(Type type) {
    return resolveOrNullRuntime(type) ?? (throw Exception('Cannot resolve [$type]'));
  }

  O resolve<T>() {
    return resolveRuntime(T);
  }
}
