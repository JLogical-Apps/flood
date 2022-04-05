import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/local_query_executor.dart';

import '../../query/query.dart';
import '../../query/request/result/query_pagination_result_controller.dart';
import '../entity_repository.dart';
import '../with_cache_entity_repository.dart';

mixin WithLocalEntityRepository on EntityRepository implements WithCacheEntityRepository {
  @override
  Future<void> save(Entity entity) async {
    // Do nothing since cache takes care of it.
  }

  @override
  Future<void> delete(Entity entity) async {
    // Do nothing since cache takes care of it.
  }

  QueryExecutor getQueryExecutor({
    required void onPaginationControllerCreated(Query query, QueryPaginationResultController controller),
  }) {
    return LocalQueryExecutor(
      stateById: getStateById(),
      onEntityInflated: (entity) async {
        await entity.onInitialize();
      },
    );
  }
}
