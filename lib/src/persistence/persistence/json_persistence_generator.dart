import 'dart:convert';

import '../export.dart';

/// A persistence generator that generates json.
abstract class JsonPersistenceGenerator<T> implements PersistenceGenerator<T, String> {
  /// Maps an object to json.
  Map<String, dynamic> toJson(T object);

  /// Maps json to an object.
  T fromJson(Map<String, dynamic> jsonObject);

  @override
  String save(T object) {
    return json.encode(toJson(object));
  }

  @override
  T load(String storage) {
    return fromJson(json.decode(storage));
  }
}
