abstract class Resolver<In, Out> {
  Out? resolveOrNull(In input);
}

extension ResolverExtensions<In, Out> on Resolver<In, Out> {
  Out resolve(In input) => resolveOrNull(input) ?? (throw Exception('Cannot resolve $input!'));
}
