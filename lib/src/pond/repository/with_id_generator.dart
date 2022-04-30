import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';

import '../../persistence/export_core.dart';

mixin WithIdGenerator<E extends Entity> on EntityRepository {
  late IdGenerator<E, String> _idGenerator = idGenerator;

  IdGenerator<E, String> get idGenerator => UuidIdGenerator();

  @override
  Future<String> generateId(Entity entity) async {
    return _idGenerator.getId(entity as E);
  }
}
