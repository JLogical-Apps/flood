import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/model/value_stream_model.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class QueryController<R extends Record, T> {
  final AbstractQueryRequest<R, T> queryRequest;

  late AsyncLoadable<T> model = ValueStreamModel(
    valueX: AppContext.global.executeQueryX(queryRequest),
    loader: () => AppContext.global.executeQuery(queryRequest),
  );

  FutureValue<T> get value => model.value;

  QueryController({required this.queryRequest});

  Future<void> reload() async {
    model.load();
  }
}
