import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/file_query_executor.dart';
import 'package:jlogical_utils/src/pond/state/persistence/json_state_persister.dart';
import 'package:jlogical_utils/src/pond/state/persistence/state_persister.dart';

mixin WithFileEntityRepository on EntityRepository implements WithCacheEntityRepository {
  StatePersister<String> get statePersister => JsonStatePersister();

  String get dataPath;

  Directory get _baseDirectory => AppContext.global.supportDirectory / dataPath;

  @override
  Future<void> onLoad(AppContext appContext) async {
    await _baseDirectory.ensureCreated();
    return super.onLoad(appContext);
  }

  @override
  Future<void> saveState(State state) async {
    final file = await _getFile(state.id!).ensureCreated();
    final json = statePersister.persist(state);
    await file.writeAsString(json, flush: true);
  }

  Future<State?> getStateOrNull(String id) async {
    final file = _getFile(id);
    if (!await file.exists()) {
      return null;
    }

    final contents = await file.readAsString();
    return guard(() => statePersister.inflate(contents), onError: (e) => print(e));
  }

  @override
  Future<void> deleteState(State state) async {
    final id = state.id ?? (throw Exception('Cannot delete state that has not been saved yet!'));
    await _getFile(id).delete();
  }

  @override
  QueryExecutor getQueryExecutor({
    required void onPaginationControllerCreated(Query query, QueryPaginationResultController controller),
  }) {
    return FileQueryExecutor(
      baseDirectory: _baseDirectory,
      stateGetter: (id) async => (await getStateOrNull(id)) ?? (throw Exception('Cannot find $id')),
      entityInflater: EntityInflater(
        stateInitializer: (state) async {
          await initializeState(state);
        },
        entityInflater: (entity) async {
          saveToCache(entity);
          await entity.onInitialize();
        },
      ),
      onPaginationControllerCreated: onPaginationControllerCreated,
    );
  }

  @override
  Future<void> onReset(AppContext context) async {
    await super.onReset(context);

    if (await _baseDirectory.exists()) {
      await _baseDirectory.delete(recursive: true);
    }
  }

  File _getFile(String id) {
    return _baseDirectory - '$id.entity';
  }
}
