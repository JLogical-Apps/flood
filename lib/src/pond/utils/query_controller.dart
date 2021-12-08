import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/model/model.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/request/abstract_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:rxdart/rxdart.dart';

class QueryController<R extends Record, T> {
  AbstractQueryRequest<R, T> queryRequest;

  QueryController({required this.queryRequest});

  late AsyncLoadable<T> model = Model(loader: () => AppContext.global.executeQuery<R, T>(queryRequest))..load();

  Future<void> reload() {
    return model.load();
  }

  ValueStream<FutureValue<T>> get valueX => model.valueX;

  FutureValue<T> get value => model.value;
}
