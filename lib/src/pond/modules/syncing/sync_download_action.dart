import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';

abstract class SyncDownloadAction {
  Future<void> download();
}

class QuerySyncDownloadAction extends SyncDownloadAction {
  final FutureOr<List<QueryRequest>> Function() queryRequestsGetter;

  QuerySyncDownloadAction(this.queryRequestsGetter);

  @override
  Future<void> download() async {
    final queryRequests = await queryRequestsGetter();
    for (final queryRequest in queryRequests) {
      await locate<SyncingModule>().executeQueryOnSource(queryRequest).timeout(Duration(seconds: 30));
    }
  }
}
