import 'package:uuid/uuid.dart';

import 'id_generator.dart';

/// Generates ids based on a uuid.
class UuidIdGenerator<T> extends IdGenerator<T, String> {
  final _uuid = Uuid();

  @override
  String getId(T? object) {
    return _uuid.v4();
  }
}
