import 'package:jlogical_utils/src/pond/query/predicate/abstract_query_predicate.dart';

import '../../../../patterns/export_core.dart';

abstract class AbstractQueryPredicateReducer<P extends AbstractQueryPredicate, C>
    with WithSubtypeWrapper<P, AbstractQueryPredicate>
    implements Wrapper<AbstractQueryPredicate> {
  const AbstractQueryPredicateReducer();

  C reduce({required C aggregate, required AbstractQueryPredicate queryPredicate});
}
