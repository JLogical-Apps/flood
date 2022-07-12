import 'dart:async';

import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/database/query/with_query_cache_manager.dart';
import 'package:jlogical_utils/src/pond/modules/debug/debuggable_module.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

abstract class EntityRepository extends AppModule
    with WithQueryCacheManager
    implements DebuggableModule, QueryExecutorX {
  List<Type> get handledEntityTypes => entityRegistrations.map((registration) => registration.entityType).toList();

  Future<String> generateId(Entity entity);

  Future<void> saveState(State state);

  Future<void> deleteState(State state);

  Future<void> initializeState(State state) async {}

  final StreamController<Entity> _entityInflatedXController = StreamController();

  Stream<Entity> get entityInflatedX => _entityInflatedXController.stream;

  Future<void> save(Entity entity) async {
    await entity.beforeSave();
    await entity.validate(null);
    await saveState(entity.state);
    await entity.afterSave();
  }

  Future<void> delete(Entity entity) async {
    await entity.beforeDelete();
    await deleteState(entity.state);
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

  /// Callback for when an [entity] in this repository is inflated.
  void onEntityInflated(Entity entity) {
    _entityInflatedXController.sink.add(entity);
  }

  EntityRepository get repository => this;

  @override
  List<Command> get debugCommands => [
        SimpleCommand(
          name: 'get',
          displayName: 'Get by ID',
          description: 'Get a state by an ID.',
          category: runtimeType.toString(),
          parameters: {
            'id': CommandParameter.string(displayName: 'ID', description: 'The ID of the state to get').required(),
          },
          runner: (args) async {
            final id = args['id'];
            final states = await onExecuteQuery(Query.from<Entity>().where(Query.id, isEqualTo: id).all().raw());
            return states.firstOrNull?.values;
          },
        ),
        SimpleCommand(
          name: 'get_all',
          displayName: 'Get All',
          description: 'Gets the first 20 elements (only the first 20 to prevent over-excessive billing).',
          category: runtimeType.toString(),
          runner: (args) async {
            final pagination = await onExecuteQuery(Query.from<Entity>().paginate());
            final firstPage = pagination.results;
            return firstPage.map((entity) => MapEntry(entity.id!, entity.state.values)).toMap();
          },
        ),
      ];
}
