import 'package:drop_core/src/repository/id/uuid_repository_id_generator.dart';

abstract class RepositoryIdGenerator {
  Future<String> generateId();

  static UuidRepositoryIdGenerator uuid() {
    return UuidRepositoryIdGenerator();
  }
}
