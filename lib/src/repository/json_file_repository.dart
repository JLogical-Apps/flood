import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/repository/persistence/json_persistence_factory.dart';

/// File repository that saves objects in json format.
abstract class JsonFileRepository<T> extends FileRepository<T> {
  JsonFileRepository({
    required Directory parentDirectory,
    required IdGenerator<T, String> idGenerator,
    required T Function(String json) fromJson,
    required String Function(T object) toJson,
  }) : super(
          idGenerator: idGenerator,
          parentDirectory: parentDirectory,
          extension: '.json',
          persistenceFactory: JsonPersistenceFactory(fromJson: fromJson, toJson: toJson),
        );
}
