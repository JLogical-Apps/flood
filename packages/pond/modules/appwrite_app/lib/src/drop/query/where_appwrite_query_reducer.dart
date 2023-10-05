import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/appwrite_query_reducer.dart';
import 'package:appwrite_app/src/drop/condition/appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/contains_appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/equals_appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/is_greater_than_appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/is_greater_than_or_equal_to_appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/is_less_than_appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/is_less_than_or_equal_to_appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/is_non_null_appwrite_query_condition_reducer.dart';
import 'package:appwrite_app/src/drop/condition/is_null_appwrite_query_condition_reducer.dart';
import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';

class WhereAppwriteQueryReducer extends AppwriteQueryReducer<WhereQuery> {
  ModifierResolver<AppwriteQueryConditionReducer, QueryCondition> getQueryConditionReducerResolver() =>
      ModifierResolver(modifiers: [
        ContainsAppwriteQueryConditionReducer(),
        EqualsAppwriteQueryConditionReducer(),
        IsGreaterThanOrEqualToAppwriteQueryConditionReducer(),
        IsGreaterThanAppwriteQueryConditionReducer(),
        IsLessThanOrEqualToAppwriteQueryConditionReducer(),
        IsLessThanAppwriteQueryConditionReducer(),
        IsNonNullAppwriteQueryConditionReducer(),
        IsNullAppwriteQueryConditionReducer(),
      ]);

  @override
  AppwriteQuery reduce(WhereQuery query, AppwriteQuery? currentAppwriteQuery) {
    return getQueryConditionReducerResolver().resolve(query.condition).reduce(query.condition, currentAppwriteQuery!);
  }
}
