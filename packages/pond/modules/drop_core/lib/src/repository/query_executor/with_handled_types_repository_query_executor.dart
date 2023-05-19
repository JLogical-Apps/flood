import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:type/type.dart';
import 'package:utils_core/utils_core.dart';

class WithHandledTypesRepositoryQueryExecutor with IsRepositoryQueryExecutorWrapper {
  @override
  final RepositoryQueryExecutor queryExecutor;

  final List<RuntimeType> handledTypes;

  WithHandledTypesRepositoryQueryExecutor({required this.queryExecutor, required this.handledTypes});

  @override
  bool handlesQuery(QueryRequest queryRequest) {
    final root = queryRequest.query.root;
    if (root is FromQuery && handledTypes.any((runtimeType) => runtimeType.type == root.entityType)) {
      return true;
    }

    if (root is FromQuery && root.entityType == typeOf<Entity>()) {
      return true;
    }

    return queryExecutor.handlesQuery(queryRequest);
  }
}
