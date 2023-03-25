import 'package:utils_core/src/patterns/resolver/map_resolver.dart';
import 'package:utils_core/src/patterns/resolver/modifier_resolver.dart';
import 'package:utils_core/src/patterns/resolver/type_resolver.dart';

abstract class Resolver<I, O> {
  O? resolveOrNull(I input);

  static MapResolver<I, O> fromMap<I, O>(Map<I, O> outputByInput) {
    return MapResolver(outputByInput: outputByInput);
  }

  static TypeResolver<O> byType<O>(List<O> objects) {
    return TypeResolver(resolvableObjects: objects);
  }

  static ModifierResolver<M, I> fromModifiers<M extends Modifier<I>, I>(List<M> wrappers) {
    return ModifierResolver(modifiers: wrappers);
  }
}

extension ResolverExtension<I, O> on Resolver<I, O> {
  O resolve(I input) => resolveOrNull(input) ?? (throw Exception('Could not resolve an output with input [$input]'));
}

mixin WithResolverDelegate<I, O> implements Resolver<I, O> {
  Resolver<I, O> get resolver;

  @override
  O? resolveOrNull(I input) => resolver.resolveOrNull(input);
}
