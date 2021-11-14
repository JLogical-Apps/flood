import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/predicate/local_equals_query_predicate_reducer.dart';

class LocalWhereQueryReducer extends WhereQueryReducer<Iterable<Record>> {
  static List<QueryPredicateReducer> queryPredicateReducers = [
    LocalEqualsQueryPredicateReducer(),
  ];

  @override
  Iterable<Record> reduce({required Iterable<Record>? aggregate, required Query query}) {
    final whereQuery = query as WhereQuery;
    final queryPredicate = whereQuery.queryPredicate;

    final queryPredicateReducer = queryPredicateReducers.firstWhere((reducer) => reducer.shouldReduce(queryPredicate));
    return queryPredicateReducer.reduce(aggregate: aggregate!, queryPredicate: queryPredicate);
  }
}
