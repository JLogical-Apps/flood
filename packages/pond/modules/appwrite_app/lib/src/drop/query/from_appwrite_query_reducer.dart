import 'package:appwrite/appwrite.dart' as appwrite;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/appwrite_query_reducer.dart';
import 'package:appwrite_app/src/util/core_pond_context_extensions.dart';
import 'package:appwrite_core/appwrite_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:type/type.dart';

class FromAppwriteQueryReducer extends AppwriteQueryReducer<FromQuery> {
  final DropCoreContext context;
  final String rootPath;

  final RuntimeType? inferredType;

  Databases get databases => context.context.appwriteCoreComponent.databases;

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
