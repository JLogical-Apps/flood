import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';

abstract class EntityRepository<E extends Entity> implements QueryExecutor {
  Future<String> generateId(E entity);

  Future<void> save(E entity);

  Future<E?> getOrNull(String id);

  Future<void> delete(String id);

  Future<E> get(String id) async {
    return (await getOrNull(id)) ?? (throw Exception('Cannot find $E with id: $id'));
  }

  Future<void> create(E entity) async {
    final id = await generateId(entity);
    entity.id = id;
    await save(entity);
  }

  Type get entityType => E;
}
