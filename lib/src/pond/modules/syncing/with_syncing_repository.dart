import 'package:jlogical_utils/src/pond/modules/syncing/syncing_module.dart';

import '../../context/app_context.dart';
import '../../query/executor/query_executor.dart';
import '../../query/query.dart';
import '../../query/request/result/query_pagination_result_controller.dart';
import '../../repository/entity_repository.dart';
import '../../state/state.dart';

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
  QueryExecutor getQueryExecutor({
    required void Function(Query query, QueryPaginationResultController controller) onPaginationControllerCreated,
  }) {
    return localRepository;
  }
}
