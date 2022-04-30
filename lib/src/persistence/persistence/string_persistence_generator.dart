import 'package:jlogical_utils/src/persistence/persistence/persistence_generator.dart';

/// A persistence generator that generates json.
abstract class StringPersistenceGenerator<T> implements PersistenceGenerator<T, String> {
  /// Maps an object to a string.
  String toPersistedString(T object);

  /// Maps a string to an object.
  T fromPersistedString(String string);

  @override
  String save(T object) {
    return toPersistedString(object);
  }

  @override
  T load(String storage) {
    return fromPersistedString(storage);
  }
}
