import 'dart:io';

import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/persistence/persistence/string_persistence_generator.dart';

import '../../../jlogical_utils.dart';

/// File data source that saves its data in json.
class StringFileDataSource<T> extends FileDataSource<T> {
  StringFileDataSource({
    required File file,
    required T Function(String string) fromString,
    required String Function(T object) toString,
  }) : super(
          file: file,
          persistenceGenerator: _LocalStringPersistenceGenerator<T>(
            fromString: fromString,
            toString: toString,
          ),
        );
}

class _LocalStringPersistenceGenerator<T> extends StringPersistenceGenerator<T> {
  final T Function(String storage) _fromPersistedString;
  final String Function(T object) _toPersistedString;

  _LocalStringPersistenceGenerator({
    required T fromString(String storage),
    required String toString(T object),
  })  : _fromPersistedString = fromString,
        _toPersistedString = toString;

  @override
  T fromPersistedString(String string) {
    return _fromPersistedString(string);
  }

  @override
  String toPersistedString(T object) {
    return _toPersistedString(object);
  }
}
