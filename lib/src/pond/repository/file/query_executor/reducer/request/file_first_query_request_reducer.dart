import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/util.dart';

import '../../../../../record/entity.dart';
import 'abstract_file_query_request_reducer.dart';

class FileFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractFileQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?> {
  final Future Function(Entity entity) onEntityInflated;

  FileFirstOrNullQueryRequestReducer({required this.onEntityInflated});

  @override
  Future<R?> reduce({
    required Iterable<State> accumulation,
    required FirstOrNullQueryRequest<R> queryRequest,
  }) async {
    final record = accumulation.firstOrNull.mapIfNonNull(Entity.fromState) as R?;
    await record.mapIfNonNull((result) => onEntityInflated(result as Entity));
    return record;
  }
}
