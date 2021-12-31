import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import 'abstract_file_query_request_reducer.dart';

class FileWithoutCacheQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<WithoutCacheQueryRequest<R, dynamic>, R, dynamic> {
  final Resolver<AbstractQueryRequest<R, dynamic>,
          AbstractFileQueryRequestReducer<AbstractQueryRequest<R, dynamic>, R, dynamic>>
      Function() queryRequestReducerResolverGetter;

  FileWithoutCacheQueryRequestReducer({required this.queryRequestReducerResolverGetter});

  @override
  dynamic reduce({
    required List<Record> accumulation,
    required WithoutCacheQueryRequest<R, dynamic> queryRequest,
  }) {
    return queryRequestReducerResolverGetter().resolve(queryRequest.queryRequest).reduce(
          accumulation: accumulation,
          queryRequest: queryRequest.queryRequest,
        );
  }
}
