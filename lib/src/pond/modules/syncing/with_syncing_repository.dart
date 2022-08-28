import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

mixin WithSyncingRepository on EntityRepository {
  EntityRepository get localRepository;

  EntityRepository get sourceRepository;

  bool get publishOnSave => true;

  late SyncingModule syncingModule = locate<SyncingModule>();

  /// Whether to cache to the local repository for the given [state].
  /// If false, then will directly interface with the sourceRepository instead.
  bool doSyncing(State state) {
    return !locate<SyncingModule>().isDisabled;
  }

  /// Whether to use the local repository for the given [queryRequest].
  /// If false, then will directly interface with the sourceRepository instead.
  bool useLocalForQueryRequest(QueryRequest queryRequest) {
    return !locate<SyncingModule>().isDisabled;
  }

  @override
  Future<void> saveState(State state) async {
    if (!doSyncing(state)) {
      return sourceRepository.saveState(state);
    }

    await localRepository.saveState(state);
    await syncingModule.enqueueSave(state);
    if (publishOnSave) {
      () async {
        await syncingModule.publish();
      }();
    }
  }

  @override
  Future<void> deleteState(State state) async {
    if (!doSyncing(state)) {
      return sourceRepository.deleteState(state);
    }

    await localRepository.deleteState(state);
    await syncingModule.enqueueDelete(state);
    if (publishOnSave) {
      () async {
        await syncingModule.publish();
      }();
    }
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    final repository = useLocalForQueryRequest(queryRequest) ? localRepository : sourceRepository;
    return repository.executeQuery(queryRequest);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    final repository = useLocalForQueryRequest(queryRequest) ? localRepository : sourceRepository;
    return repository.executeQueryX(queryRequest);
  }
}
