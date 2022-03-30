import 'package:jlogical_utils/src/patterns/resolver/resolver.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/without_cache_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import 'abstract_file_query_request_reducer.dart';

class FileWithoutCacheQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<WithoutCacheQueryRequest<R, dynamic>, R, dynamic> {
  final Resolver<QueryRequest<R, dynamic>,
          AbstractQueryRequestReducer<QueryRequest<R, dynamic>, R, dynamic, Iterable<State>>>
      Function() queryRequestReducerResolverGetter;

  FileWithoutCacheQueryRequestReducer({required this.queryRequestReducerResolverGetter});

  @override
  dynamic reduceSync({
    required Iterable<State> accumulation,
    required WithoutCacheQueryRequest<R, dynamic> queryRequest,
  }) {
    return queryRequestReducerResolverGetter().resolve(queryRequest.queryRequest).reduce(
          accumulation: accumulation,
          queryRequest: queryRequest.queryRequest,
        );
  }

  @override
  Future<void> inflate(output) async {
  }
}
