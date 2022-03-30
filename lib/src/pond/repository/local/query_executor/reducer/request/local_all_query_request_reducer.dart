import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../record/entity.dart';
import 'abstract_local_query_request_reducer.dart';

class LocalAllQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<AllQueryRequest<R>, R, List<R>> {
  final Future Function(Entity entity) onEntityInflated;

  LocalAllQueryRequestReducer({required this.onEntityInflated});

  @override
  List<R> reduceSync({
    required Iterable<State> accumulation,
    required AllQueryRequest<R> queryRequest,
  }) {
    return accumulation.map((state) => Entity.fromState(state)).cast<R>().toList();
  }

  @override
  Future<void> inflate(List<R> output) {
    return Future.wait(output.map((value) => onEntityInflated(value as Entity)));
  }
}
