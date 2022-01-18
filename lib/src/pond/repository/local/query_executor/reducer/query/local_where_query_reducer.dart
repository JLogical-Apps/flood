import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/with_wrapper_resolver.dart';
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/predicate/local_contains_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/predicate/local_equals_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/predicate/local_greater_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/predicate/local_greater_than_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/predicate/local_less_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/local/query_executor/reducer/predicate/local_less_than_query_predicate_reducer.dart';

class LocalWhereQueryReducer extends AbstractWhereQueryReducer<Iterable<Record>>
    with WithWrapperResolver<AbstractQueryPredicate, AbstractQueryPredicateReducer>
    implements Resolver<AbstractQueryPredicate, AbstractQueryPredicateReducer> {
  late List<AbstractQueryPredicateReducer> wrappers = [
    LocalEqualsQueryPredicateReducer(),
    LocalContainsQueryPredicateReducer(),
    LocalGreaterThanQueryPredicateReducer(),
    LocalGreaterThanOrEqualToQueryPredicateReducer(),
    LocalLessThanQueryPredicateReducer(),
    LocalLessThanOrEqualToQueryPredicateReducer(),
  ];

  @override
  Future<Iterable<Record>> reduce({required Iterable<Record>? accumulation, required Query query}) async {
    final whereQuery = query as WhereQuery;
    final queryPredicate = whereQuery.queryPredicate;

    final queryPredicateReducer = resolve(queryPredicate);
    return queryPredicateReducer.reduce(aggregate: accumulation!, queryPredicate: queryPredicate);
  }
}