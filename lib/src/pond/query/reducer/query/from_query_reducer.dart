import 'package:jlogical_utils/src/pond/query/from_query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/query_reducer.dart';

abstract class FromQueryReducer<C> extends QueryReducer<FromQuery, C> {
  const FromQueryReducer();
}
