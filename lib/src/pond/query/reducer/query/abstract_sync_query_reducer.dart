import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';

abstract class AbstractSyncQueryReducer<Q extends Query, C> extends AbstractQueryReducer<Q, C> {
  const AbstractSyncQueryReducer();

  C reduceSync({required C? accumulation, required Query query});

  @override
  Future<C> reduce({required C? accumulation, required Query query}) async {
    return reduceSync(accumulation: accumulation, query: query);
  }
}
