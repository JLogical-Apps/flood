abstract class Resolver<In, Out> {
  Out resolve<V extends In>(V input);
}