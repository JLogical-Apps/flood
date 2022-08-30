import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';

abstract class SyncDownloadAction {
  final SyncDownloadPriority priority;

  const SyncDownloadAction({this.priority: SyncDownloadPriority.high});

  Future<void> download();
}

class QuerySyncDownloadAction extends SyncDownloadAction {
  final FutureOr<List<QueryRequest>> Function() queryRequestsGetter;

  QuerySyncDownloadAction(this.queryRequestsGetter, {super.priority: SyncDownloadPriority.high});

  @override
  Future<void> download() async {
    final queryRequests = await queryRequestsGetter();
    for (final queryRequest in queryRequests) {
      await locate<SyncingModule>().executeQueryOnSource(queryRequest);
    }
  }
}

enum SyncDownloadPriority {
  /// Critical download, these must be downloaded before the app can be used.
  high,

  /// Not a critical download, these are downloaded in the background.
  low,
}
