import 'dart:convert';

import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

import '../persistence.dart';

/// A persistence generator that generates yaml. Currently does not support saving to yaml, only reading from yaml.
abstract class YamlPersistenceGenerator<T> implements PersistenceGenerator<T, String> {
  /// Maps an object to json, which will be converted to yaml when saving.
  Map<String, dynamic> toJson(T object);

  /// Maps the yaml's json to an object.
  T fromJson(Map<String, dynamic> jsonObject);

  @override
  String save(T object) {
    return json2yaml(toJson(object));
  }

  @override
  T load(String storage) {
    return fromJson(json.decode(json.encode(loadYaml(storage))));
  }
}
