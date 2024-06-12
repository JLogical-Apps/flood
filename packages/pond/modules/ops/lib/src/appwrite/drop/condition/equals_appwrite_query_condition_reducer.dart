import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/condition/appwrite_query_condition_reducer.dart';

class EqualsAppwriteQueryConditionReducer extends AppwriteQueryConditionReducer<EqualsQueryCondition> {
  @override
  AppwriteQuery reduce(EqualsQueryCondition condition, AppwriteQuery currentAppwriteQuery) {
    if (condition.stateField == State.idField) {
      return currentAppwriteQuery.withQuery(appwrite.Query.equal('\$id', condition.value));
    }

    if (condition.value == null) {
      return currentAppwriteQuery.withQuery(appwrite.Query.isNull(condition.stateField));
    }

    return currentAppwriteQuery.withQuery(appwrite.Query.equal(condition.stateField, condition.value));
  }
}
