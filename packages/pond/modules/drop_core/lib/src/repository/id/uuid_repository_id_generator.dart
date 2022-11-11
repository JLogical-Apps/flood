import 'package:drop_core/src/repository/repository_id_generator.dart';
import 'package:uuid/uuid.dart';

class UuidRepositoryIdGenerator implements RepositoryIdGenerator {
  @override
  Future<String> generateId() async {
    return Uuid().v4();
  }
}
