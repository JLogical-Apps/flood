import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:utils_core/utils_core.dart';

abstract class AppwriteQueryConditionReducer<QC extends QueryCondition> extends Modifier<QueryCondition> {
  @override
  bool shouldModify(QueryCondition input) {
    return input is QC;
  }

  AppwriteQuery reduce(QC condition, AppwriteQuery currentAppwriteQuery);
}
