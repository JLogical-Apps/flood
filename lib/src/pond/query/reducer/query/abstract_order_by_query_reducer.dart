import 'package:jlogical_utils/src/pond/query/order_by_query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';

abstract class AbstractOrderByQueryReducer<C> extends AbstractQueryReducer<OrderByQuery, C> {
  const AbstractOrderByQueryReducer();
}
