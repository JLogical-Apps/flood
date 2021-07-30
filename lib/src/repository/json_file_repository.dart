import 'dart:convert';
import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/repository/persistence/json_persistence_generator.dart';

/// File repository that saves objects in json format.
abstract class JsonFileRepository<T> extends FileRepository<T> {
  JsonFileRepository({
    required Directory parentDirectory,
    required IdGenerator<T, String> idGenerator,
    required T Function(Map<String, dynamic> json) fromJson,
    required Map<String, dynamic> Function(T object) toJson,
  }) : super(
          idGenerator: idGenerator,
          parentDirectory: parentDirectory,
          extension: '.json',
          persistenceFactory: JsonPersistenceGenerator(
            fromJson: (jsonText) => fromJson(json.decode(jsonText)),
            toJson: (obj) => json.encode(toJson(obj)),
          ),
        );
}
