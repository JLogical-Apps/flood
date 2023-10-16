import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/condition/appwrite_query_condition_reducer.dart';
import 'package:drop_core/drop_core.dart';

class ContainsAppwriteQueryConditionReducer extends AppwriteQueryConditionReducer<ContainsQueryCondition> {
  @override
  AppwriteQuery reduce(ContainsQueryCondition condition, AppwriteQuery currentAppwriteQuery) {
    return currentAppwriteQuery.withQuery(appwrite.Query.search(condition.stateField, condition.value));
  }
}
