import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/file_query_executor.dart';
import 'package:jlogical_utils/src/pond/state/persistence/json_state_persister.dart';
import 'package:jlogical_utils/src/pond/state/persistence/state_persister.dart';
import 'package:path/path.dart';

mixin WithFileEntityRepository on EntityRepository implements WithTransactionsAndCacheEntityRepository {
  Directory get baseDirectory;

  StatePersister<String> get statePersister => JsonStatePersister();

  @override
  Future<void> save(Entity entity, {Transaction? transaction}) {
    return _saveState(id: entity.id!, state: entity.state);
  }

  Future<void> _saveState({required String id, required State state}) async {
    final file = await _getFile(id).ensureCreated();
    final json = statePersister.persist(state);
    await file.writeAsString(json);
  }

  @override
  Future<Entity?> getOrNull(String id, {Transaction? transaction, bool withoutCache: false}) async {
    final file = _getFile(id);
    if (!await file.exists()) {
      return null;
    }

    final contents = await file.readAsString();
    return guard(() => statePersister.inflate(contents))
        .mapIfNonNull((inflatedState) => Entity.fromStateOrNull(inflatedState));
  }

  @override
  Future<void> delete(String id, {Transaction? transaction}) async {
    await _getFile(id).delete();
  }

  Future<void> commitTransactionChanges(TransactionPendingChanges changes) async {
    await Future.wait(changes.stateChangesById.entries.mapEntries((id, state) => _saveState(id: id, state: state)));
    await Future.wait(changes.stateIdDeletes.map((id) => delete(id)));
  }

  QueryExecutor getQueryExecutor({Transaction? transaction}) {
    return FileQueryExecutor(
      baseDirectory: baseDirectory,
      stateGetter: (id, withoutCache) async =>
          (await get(id, transaction: transaction, withoutCache: withoutCache)).state,
    );
  }

  File _getFile(String id) {
    return File(join(baseDirectory.path, id));
  }
}
