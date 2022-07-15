import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

mixin WithSyncingRepository on EntityRepository {
  EntityRepository get localRepository;

  EntityRepository get sourceRepository;

  late SyncingModule syncingModule = locate<SyncingModule>();

  @override
  Future<void> saveState(State state) async {
    await localRepository.saveState(state);
    await syncingModule.enqueueSave(state);
  }

  @override
  Future<void> deleteState(State state) async {
    await localRepository.deleteState(state);
    await syncingModule.enqueueDelete(state);
  }

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return localRepository.executeQuery(queryRequest);
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) {
    return localRepository.executeQueryX(queryRequest);
  }
}
