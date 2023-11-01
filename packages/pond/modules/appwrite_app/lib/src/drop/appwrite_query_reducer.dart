import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';

abstract class AppwriteQueryReducer<Q extends Query> extends Modifier<Query> {
  @override
  bool shouldModify(Query input) {
    return input is Q;
  }

  AppwriteQuery reduce(Q query, AppwriteQuery? currentAppwriteQuery);
}
