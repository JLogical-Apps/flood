import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_contains_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_equals_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_greater_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_greater_than_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_less_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_less_than_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../../patterns/export_core.dart';
import '../predicate/file_not_equals_query_predicate_reducer.dart';

class FileWhereQueryReducer extends AbstractQueryReducer<WhereQuery, Iterable<State>>
    with WithWrapperResolver<AbstractQueryPredicate, AbstractQueryPredicateReducer>
    implements Resolver<AbstractQueryPredicate, AbstractQueryPredicateReducer> {
  late List<AbstractQueryPredicateReducer> wrappers = [
    FileEqualsQueryPredicateReducer(),
    FileNotEqualsQueryPredicateReducer(),
    FileContainsQueryPredicateReducer(),
    FileGreaterThanQueryPredicateReducer(),
    FileGreaterThanOrEqualToQueryPredicateReducer(),
    FileLessThanQueryPredicateReducer(),
    FileLessThanOrEqualToQueryPredicateReducer(),
  ];

  @override
  Future<Iterable<State>> reduce({required Iterable<State>? accumulation, required Query query}) async {
    final whereQuery = query as WhereQuery;
    final queryPredicate = whereQuery.queryPredicate;

    final queryPredicateReducer = resolve(queryPredicate);
    return queryPredicateReducer.reduce(aggregate: accumulation!, queryPredicate: queryPredicate);
  }
}
