import '../../query/request/query_request.dart';

class QueryDownloadScope {
  final QueryRequest Function() queryRequestGetter;

  const QueryDownloadScope(this.queryRequestGetter);

  QueryRequest getQueryRequest() {
    return queryRequestGetter();
  }
}
