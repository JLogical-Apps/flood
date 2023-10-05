import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/appwrite_query_reducer.dart';
import 'package:drop_core/drop_core.dart';

class OrderByAppwriteQueryReducer extends AppwriteQueryReducer<OrderByQuery> {
  @override
  AppwriteQuery reduce(OrderByQuery query, AppwriteQuery? currentAppwriteQuery) {
    return currentAppwriteQuery!.withQuery(query.type == OrderByType.descending
        ? appwrite.Query.orderDesc(query.stateField)
        : appwrite.Query.orderAsc(query.stateField));
  }
}
