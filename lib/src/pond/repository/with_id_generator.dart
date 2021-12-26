import 'package:jlogical_utils/src/persistence/ids/id_generator.dart';
import 'package:jlogical_utils/src/persistence/ids/incremental_id_generator.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';

mixin WithIdGenerator<E extends Entity> on EntityRepository {
  late IdGenerator<E, String> _idGenerator = idGenerator;

  IdGenerator<E, String> get idGenerator => PrefixedIncrementalIdGenerator(prefix: E.toString());

  @override
  Future<String> generateId(Entity entity, {Transaction? transaction}) async {
    return _idGenerator.getId(entity as E);
  }
}
