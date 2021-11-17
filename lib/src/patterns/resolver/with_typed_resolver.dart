import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';

mixin WithTypedResolver<In, Out> implements Resolver<In, Out> {
  Map<Type, Out> get outputByType;

  @override
  Out resolve<V extends In>(V input) {
    return outputByType[V] ?? (throw Exception('No resolver has been registered for type [$V] for input [$input]'));
  }
}
