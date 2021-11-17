import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';

mixin WithResolverProvider<In, Out> implements Resolver<In, Out> {
  Resolver<In, Out> get resolver;

  Out resolve<V extends In>(V input) {
    return resolver.resolve(input);
  }
}
