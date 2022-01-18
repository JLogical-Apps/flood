import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/patterns/resolver/with_wrapper_resolver.dart';
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/predicate/abstract_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_where_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/where_query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_contains_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_equals_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_greater_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_greater_than_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_less_than_or_equal_to_query_predicate_reducer.dart';
import 'package:jlogical_utils/src/pond/repository/file/query_executor/reducer/predicate/file_less_than_query_predicate_reducer.dart';

class FileWhereQueryReducer extends AbstractWhereQueryReducer<Iterable<Record>>
    with WithWrapperResolver<AbstractQueryPredicate, AbstractQueryPredicateReducer>
    implements Resolver<AbstractQueryPredicate, AbstractQueryPredicateReducer> {
  late List<AbstractQueryPredicateReducer> wrappers = [
    FileEqualsQueryPredicateReducer(),
    FileContainsQueryPredicateReducer(),
    FileGreaterThanQueryPredicateReducer(),
    FileGreaterThanOrEqualToQueryPredicateReducer(),
    FileLessThanQueryPredicateReducer(),
    FileLessThanOrEqualToQueryPredicateReducer(),
  ];

  @override
  Future<Iterable<Record>> reduce({required Iterable<Record>? accumulation, required Query query}) async {
    final whereQuery = query as WhereQuery;
    final queryPredicate = whereQuery.queryPredicate;

    final queryPredicateReducer = resolve(queryPredicate);
    return queryPredicateReducer.reduce(aggregate: accumulation!, queryPredicate: queryPredicate);
  }
}