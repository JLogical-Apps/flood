import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_local_query_request_reducer.dart';

class LocalWithoutCacheQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<WithoutCacheQueryRequest<R, List<Record>>, R, List<Record>> {
  final Resolver<AbstractQueryRequest<R, dynamic>,
          AbstractLocalQueryRequestReducer<AbstractQueryRequest<R, dynamic>, R, dynamic>>
      Function() queryRequestReducerResolverGetter;

  LocalWithoutCacheQueryRequestReducer({required this.queryRequestReducerResolverGetter});

  @override
  List<R> reduce({
    required List<Record> accumulation,
    required WithoutCacheQueryRequest<R, List<Record>> queryRequest,
  }) {
    return queryRequestReducerResolverGetter().resolve(queryRequest.queryRequest).reduce(
          accumulation: accumulation,
          queryRequest: queryRequest.queryRequest,
        );
  }
}
