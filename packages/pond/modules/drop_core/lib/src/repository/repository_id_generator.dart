import 'package:drop_core/src/repository/id/uuid_repository_id_generator.dart';

abstract class RepositoryIdGenerator {
  static UuidRepositoryIdGenerator uuid() {
    return UuidRepositoryIdGenerator();
  }
}
