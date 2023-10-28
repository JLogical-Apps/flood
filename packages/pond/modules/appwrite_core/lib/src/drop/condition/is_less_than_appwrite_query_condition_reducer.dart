import 'package:appwrite_core/appwrite_implementation.dart' as appwrite;
import 'package:appwrite_core/src/drop/appwrite_query.dart';
import 'package:drop_core/drop_core.dart';
import 'package:appwrite_core/src/drop/condition/appwrite_query_condition_reducer.dart';

class IsLessThanAppwriteQueryConditionReducer extends AppwriteQueryConditionReducer<IsLessThanQueryCondition> {
  @override
  AppwriteQuery reduce(IsLessThanQueryCondition condition, AppwriteQuery currentAppwriteQuery) {
    return currentAppwriteQuery.withQuery(appwrite.Query.lessThan(condition.stateField, condition.value));
  }
}
