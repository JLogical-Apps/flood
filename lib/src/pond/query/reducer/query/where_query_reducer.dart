import 'package:jlogical_utils/src/pond/query/reducer/query/query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';

abstract class WhereQueryReducer<C> extends QueryReducer<WhereQuery, C> {
  const WhereQueryReducer();
}