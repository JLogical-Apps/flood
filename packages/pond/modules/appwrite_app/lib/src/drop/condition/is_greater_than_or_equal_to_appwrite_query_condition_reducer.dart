import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:drop_core/drop_core.dart';
import 'package:appwrite_app/src/drop/condition/appwrite_query_condition_reducer.dart';

class IsGreaterThanOrEqualToAppwriteQueryConditionReducer
    extends AppwriteQueryConditionReducer<IsGreaterThanOrEqualToQueryCondition> {
  @override
  AppwriteQuery reduce(IsGreaterThanOrEqualToQueryCondition condition, AppwriteQuery currentAppwriteQuery) {
    return currentAppwriteQuery.withQuery(appwrite.Query.greaterThanEqual(condition.stateField, condition.value));
  }
}
