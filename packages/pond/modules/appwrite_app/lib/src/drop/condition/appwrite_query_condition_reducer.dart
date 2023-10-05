import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';

abstract class AppwriteQueryConditionReducer<QC extends QueryCondition> extends Modifier<QueryCondition> {
  @override
  bool shouldModify(QueryCondition input) {
    return input is QC;
  }

  AppwriteQuery reduce(QC condition, AppwriteQuery currentAppwriteQuery);
}
