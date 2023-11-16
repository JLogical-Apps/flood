import 'package:appwrite_core/appwrite_core.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_reducer.dart';
import 'package:ops/src/appwrite/util/appwrite_core_component_extensions.dart';
import 'package:runtime_type/type.dart';

class FromAppwriteQueryReducer extends AppwriteQueryReducer<FromQuery> {
  final DropCoreContext context;
  final String rootPath;

  final RuntimeType? inferredType;

  late final Databases databases = Databases(context.context.client);

  FromAppwriteQueryReducer({required this.context, required this.rootPath, this.inferredType});

  @override
  AppwriteQuery reduce(FromQuery query, AppwriteQuery? currentAppwriteQuery) {
    if (query.entityType == Entity) {
      return AppwriteQuery(databases: databases, collectionId: rootPath);
    }

    final queryEntityRuntimeType = context.getRuntimeTypeRuntime(query.entityType);

    if (queryEntityRuntimeType == inferredType) {
      return AppwriteQuery(databases: databases, collectionId: rootPath);
    }

    final shouldNarrowByType = query.entityType != Entity;
    if (!shouldNarrowByType) {
      return AppwriteQuery(databases: databases, collectionId: rootPath);
    }

    final descendants = context.getDescendantsOf(queryEntityRuntimeType);
    final types = {...descendants, queryEntityRuntimeType};
    final typeNames = types.map((type) => type.name).toList();

    return AppwriteQuery(databases: databases, collectionId: rootPath)
        .withQuery(appwrite.Query.equal(AppwriteConsts.typeKey, typeNames));
  }
}
