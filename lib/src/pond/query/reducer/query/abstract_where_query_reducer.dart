import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';

abstract class AbstractWhereQueryReducer<C> extends AbstractQueryReducer<WhereQuery, C> {
  const AbstractWhereQueryReducer();
}