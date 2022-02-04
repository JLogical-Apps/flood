import 'package:jlogical_utils/src/model/async_loadable.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/model/value_stream_model.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class QueryController<R extends Record, T> {
  final QueryRequest<R, T> queryRequest;

  late AsyncLoadable<T> model = ValueStreamModel(
    valueX: AppContext.global.executeQueryX(queryRequest),
    loader: () => AppContext.global.executeQuery(queryRequest.withoutCache()),
    hasStartedLoading: true,
  );

  FutureValue<T> get value => model.value;

  QueryController({required this.queryRequest});

  Future<void> reload() async {
    model.load();
  }
}
