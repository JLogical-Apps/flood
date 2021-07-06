import 'package:uuid/uuid.dart';

import 'id_generator.dart';

/// Generates ids based on a uuid.
class UuidIdGenerator<T> extends IdGenerator<T, String> {
  final uuid = Uuid();

  @override
  String getId(T object) {
    return uuid.v4();
  }
}
