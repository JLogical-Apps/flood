import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_reducer.dart';

class OrderByAppwriteQueryReducer extends AppwriteQueryReducer<OrderByQuery> {
  @override
  AppwriteQuery reduce(OrderByQuery query, AppwriteQuery? currentAppwriteQuery) {
    return currentAppwriteQuery!.withQuery(query.type == OrderByType.descending
        ? appwrite.Query.orderDesc(query.stateField)
        : appwrite.Query.orderAsc(query.stateField));
  }
}
