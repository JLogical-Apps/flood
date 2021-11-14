import 'package:jlogical_utils/src/pond/query/query.dart';

abstract class QueryReducer<Q extends Query, C> {
  const QueryReducer();

  bool shouldReduce(Query query) => query is Q;

  C reduce({required C? aggregate, required Query query});
}
