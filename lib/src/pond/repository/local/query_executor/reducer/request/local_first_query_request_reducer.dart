import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/request/first_or_null_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/util.dart';

import '../../../../../record/entity.dart';
import 'abstract_local_query_request_reducer.dart';

class LocalFirstOrNullQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?> {
  final EntityInflater entityInflater;

  LocalFirstOrNullQueryRequestReducer({required this.entityInflater});

  @override
  R? reduceSync({
    required Iterable<State> accumulation,
    required FirstOrNullQueryRequest<R> queryRequest,
  }) {
    return accumulation.firstOrNull.mapIfNonNull(Entity.fromState) as R?;
  }

  @override
  Future<R?> inflate(R? output) async {
    final state = output?.state;
    await state.mapIfNonNull((state) => entityInflater.initializeState(state));

    final newOutput = state.mapIfNonNull(Entity.fromState) as R?;
    await newOutput.mapIfNonNull((value) => entityInflater.inflateEntity(value as Entity));

    return newOutput;
  }
}
