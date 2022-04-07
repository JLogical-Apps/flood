import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/database/query/with_query_cache_manager.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

abstract class EntityRepository extends AppModule with WithQueryCacheManager implements QueryExecutorX {
  List<Type> get handledEntityTypes => entityRegistrations.map((registration) => registration.entityType).toList();

  Future<String> generateId(Entity entity);

  Future<void> saveState(State state);

  Future<void> deleteState(State state);

  Future<void> initializeState(State state) async {}

  Future<void> save(Entity entity) {
    return saveState(entity.state);
  }

  Future<void> delete(Entity entity) {
    return deleteState(entity.state);
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
