import 'package:jlogical_utils/src/repository/persistence/persistence_factory.dart';

/// A persistence factory that generates json.
/// Very useful if applied alongside [json_serializable ] or [freezed].
class JsonPersistenceFactory<T> implements PersistenceFactory<T, String> {
  /// Maps json to an object.
  final T Function(String json) fromJson;

  /// Maps an object to json.
  final String Function(T object) toJson;

  const JsonPersistenceFactory({required this.fromJson, required this.toJson});

  @override
  String save(T object) {
    return toJson(object);
  }

  @override
  T load(String storage) {
    return fromJson(storage);
  }
}
