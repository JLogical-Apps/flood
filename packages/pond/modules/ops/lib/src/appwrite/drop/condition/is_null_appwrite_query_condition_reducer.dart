import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/condition/appwrite_query_condition_reducer.dart';
import 'package:drop_core/drop_core.dart';

class IsNullAppwriteQueryConditionReducer extends AppwriteQueryConditionReducer<IsNullQueryCondition> {
  @override
  AppwriteQuery reduce(IsNullQueryCondition condition, AppwriteQuery currentAppwriteQuery) {
    return currentAppwriteQuery.withQuery(appwrite.Query.isNull(condition.stateField));
  }
}
