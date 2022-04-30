import 'package:jlogical_utils/src/pond/query/query.dart';

import '../../../../patterns/export_core.dart';

abstract class AbstractQueryReducer<Q extends Query, C> with WithSubtypeWrapper<Q, Query> implements Wrapper<Query> {
  const AbstractQueryReducer();

  Future<C> reduce({required C? accumulation, required Query query});
}
