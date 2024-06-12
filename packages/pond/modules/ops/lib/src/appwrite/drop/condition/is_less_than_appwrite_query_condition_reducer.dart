import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/condition/appwrite_query_condition_reducer.dart';

class IsLessThanAppwriteQueryConditionReducer extends AppwriteQueryConditionReducer<IsLessThanQueryCondition> {
  @override
  AppwriteQuery reduce(IsLessThanQueryCondition condition, AppwriteQuery currentAppwriteQuery) {
    return currentAppwriteQuery.withQuery(appwrite.Query.lessThan(condition.stateField, condition.value));
  }
}
