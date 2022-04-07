import 'dart:async';

import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';

import '../../../record/entity.dart';
import '../../../record/record.dart';
import '../../../state/state.dart';
import '../../request/first_or_null_query_request.dart';

mixin WithFirstQueryRequestReducer<R extends Record, C>
    on AbstractQueryRequestReducer<FirstOrNullQueryRequest<R>, R, R?, C> {
  EntityInflater get entityInflater;

  FutureOr<State?> getState(C accumulation);

  Future<R?> reduce({required C accumulation, required FirstOrNullQueryRequest<R> queryRequest}) async {
    final state = await getState(accumulation);
    if (state == null) {
      return null;
    }

    await entityInflater.initializeState(state);

    final record = Entity.fromState(state) as R?;
    if (record != null) {
      await entityInflater.inflateEntity(record as Entity);
    }

    return record;
  }
}
