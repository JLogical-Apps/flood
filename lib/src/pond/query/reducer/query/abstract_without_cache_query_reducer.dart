import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';

abstract class AbstractWithoutCacheQueryReducer<C> extends AbstractQueryReducer<WithoutCacheQuery, C> {
  const AbstractWithoutCacheQueryReducer();
}
