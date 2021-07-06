/// Generates a persistence format for objects and converts them from persistence.
abstract class PersistenceFactory<T, P> {
  /// Returns the persistence format for [object].
  P save(T object);

  /// Returns an object from the persisted [storage].
  T load(P storage);
}
