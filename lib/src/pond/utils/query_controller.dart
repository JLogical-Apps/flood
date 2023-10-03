import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

import '../../model/export_core.dart';

class QueryController<R extends Record, T> {
  final QueryRequest<R, T> queryRequest;
  final QueryExecutorX queryExecutorX;

  late AsyncLoadable<T> model = ValueStreamModel(
    valueX: queryExecutorX.executeQueryX(queryRequest),
    loader: () => queryExecutorX.executeQuery(queryRequest.withoutCache()),
    hasStartedLoading: true,
  );

  FutureValue<T> get value => model.value;

  QueryController({required this.queryRequest, QueryExecutorX? queryExecutorX})
      : this.queryExecutorX = queryExecutorX ?? AppContext.global;

  Future<void> reload() async {
    model.load();
  }
}