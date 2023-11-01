import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_reducer.dart';
import 'package:drop_core/drop_core.dart';

class LimitAppwriteQueryReducer extends AppwriteQueryReducer<LimitQuery> {
  @override
  AppwriteQuery reduce(LimitQuery query, AppwriteQuery? currentAppwriteQuery) {
    return currentAppwriteQuery!.withQuery(appwrite.Query.limit(query.limit));
  }
}
