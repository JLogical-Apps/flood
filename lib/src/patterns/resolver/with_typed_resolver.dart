import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';

mixin WithTypedResolver<In, Out> implements Resolver<In, Out> {
  Map<Type, Out> get outputByType;

  @override
  Out resolve(In input) {
    return outputByType[input.runtimeType] ?? (throw Exception('No resolver has been registered for input [$input]'));
  }
}
