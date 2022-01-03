import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

abstract class AbstractQueryPredicateReducer<P extends AbstractQueryPredicate, C>
    with WithSubtypeWrapper<P, AbstractQueryPredicate>
    implements Wrapper<AbstractQueryPredicate> {
  const AbstractQueryPredicateReducer();

  C reduce({required C aggregate, required AbstractQueryPredicate queryPredicate});
}
