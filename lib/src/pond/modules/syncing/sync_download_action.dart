import '../../query/request/query_request.dart';

abstract class SyncDownloadAction {
  Future<void> download();
}

class QuerySyncDownloadAction extends SyncDownloadAction {
  final QueryRequest Function() queryRequestGetter;

  QuerySyncDownloadAction(this.queryRequestGetter);

  @override
  Future<void> download() async {
    final queryRequest = queryRequestGetter();
    await queryRequest.get();
  }
}
