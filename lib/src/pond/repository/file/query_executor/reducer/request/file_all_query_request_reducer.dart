import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../record/entity.dart';
import 'abstract_file_query_request_reducer.dart';

class FileAllQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<AllQueryRequest<R>, R, List<R>> {

  final Future Function(Entity entity) onEntityInflated;

  FileAllQueryRequestReducer({required this.onEntityInflated});

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
