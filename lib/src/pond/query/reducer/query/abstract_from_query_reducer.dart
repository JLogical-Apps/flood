import 'package:jlogical_utils/src/pond/query/from_query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';

abstract class AbstractFromQueryReducer<C> extends AbstractQueryReducer<FromQuery, C> {
  const AbstractFromQueryReducer();
}
