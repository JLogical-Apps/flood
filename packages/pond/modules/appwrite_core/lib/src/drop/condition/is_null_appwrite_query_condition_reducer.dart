import 'package:appwrite_core/appwrite_implementation.dart' as appwrite;
import 'package:appwrite_core/src/drop/appwrite_query.dart';
import 'package:appwrite_core/src/drop/condition/appwrite_query_condition_reducer.dart';
import 'package:drop_core/drop_core.dart';

class IsNullAppwriteQueryConditionReducer extends AppwriteQueryConditionReducer<IsNullQueryCondition> {
  @override
  AppwriteQuery reduce(IsNullQueryCondition condition, AppwriteQuery currentAppwriteQuery) {
    return currentAppwriteQuery.withQuery(appwrite.Query.isNull(condition.stateField));
  }
}
