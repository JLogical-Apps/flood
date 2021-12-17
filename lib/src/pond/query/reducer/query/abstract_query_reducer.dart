import 'package:jlogical_utils/src/patterns/wrapper/with_subtype_wrapper.dart';
import 'package:jlogical_utils/src/patterns/wrapper/wrapper.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';

abstract class AbstractQueryReducer<Q extends Query, C> with WithSubtypeWrapper<Q, Query> implements Wrapper<Query> {
  const AbstractQueryReducer();

  C reduce({required C? accumulation, required Query query});
}
