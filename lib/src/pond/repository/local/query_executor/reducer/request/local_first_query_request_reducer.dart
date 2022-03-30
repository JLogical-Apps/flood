import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/util.dart';

import '../../../../../record/entity.dart';
import 'abstract_local_query_request_reducer.dart';

class LocalFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?> {
  final Future Function(Entity entity) onEntityInflated;

  LocalFirstOrNullQueryRequestReducer({required this.onEntityInflated});

  @override
  R? reduceSync({
    required Iterable<State> accumulation,
    required FirstOrNullQueryRequest<R> queryRequest,
  }) {
    return accumulation.firstOrNull.mapIfNonNull(Entity.fromState) as R?;
  }

  @override
  Future<void> inflate(R? output) async {
    await output.mapIfNonNull((value) => onEntityInflated(value as Entity));
  }
}
