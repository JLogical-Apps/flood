import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/database/query/with_query_cache_manager.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:rxdart/rxdart.dart';

abstract class EntityRepository extends AppModule with WithQueryCacheManager implements QueryExecutorX {
  List<Type> get handledEntityTypes;

  Future<String> generateId(Entity entity);

  Future<void> save(Entity entity);

  Future<Entity?> getOrNull(String id, {bool withoutCache: false});

  ValueStream<FutureValue<Entity?>> getXOrNull(String id);

  Future<void> delete(Entity entity);

  Future<Entity> get(String id, {bool withoutCache: false}) async {
    return (await getOrNull(id, withoutCache: withoutCache)) ??
        (throw Exception('Cannot find entity with id [$id] from repository [$this]'));
  }

  Future<void> create(Entity entity) async {
    final id = await generateId(entity);
    entity.id = id;
    await save(entity);
    await entity.onInitialize();
    await entity.afterCreate();
  }

  Future<void> createOrSave(Entity entity) {
    if (entity.isNew) {
      return create(entity);
    } else {
      return save(entity);
    }
  }

  EntityRepository get repository => this;
}
