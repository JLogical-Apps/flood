import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:utils_core/utils_core.dart';

abstract class AppwriteQueryReducer<Q extends Query> extends Modifier<Query> {
  @override
  bool shouldModify(Query input) {
    return input is Q;
  }

  AppwriteQuery reduce(Q query, AppwriteQuery? currentAppwriteQuery);
}
