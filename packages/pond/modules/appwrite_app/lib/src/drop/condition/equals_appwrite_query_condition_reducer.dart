import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/condition/appwrite_query_condition_reducer.dart';
import 'package:drop_core/drop_core.dart';

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
