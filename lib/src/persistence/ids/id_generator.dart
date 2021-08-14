/// Generates unique ids for objects.
/// [T] is the type of object this will generate ids for.
/// [R] is the type of ids this will generate.
abstract class IdGenerator<T, R> {
  /// Generates an id for [object].
  R getId(T? object);
}
