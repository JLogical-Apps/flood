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
  Future<List<R>> reduce({
    required Iterable<State> accumulation,
    required AllQueryRequest<R> queryRequest,
  }) async {
    final records = accumulation.map((state) => Entity.fromState(state)).cast<R>().toList();
    await Future.wait(records.map((value) => onEntityInflated(value as Entity)));
    return records;
  }
}
