import 'dart:async';

import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';

import '../../../record/entity.dart';
import '../../../record/record.dart';
import '../../../state/state.dart';
import '../../request/all_query_request.dart';

mixin WithAllQueryRequestReducer<R extends Record, C>
    on AbstractQueryRequestReducer<AllQueryRequest<R>, R, List<R>, C> {
  EntityInflater get entityInflater;

  FutureOr<List<State>> getStates(C accumulation);

  Future<List<R>> reduce({required C accumulation, required AllQueryRequest<R> queryRequest}) async {
    final states = await getStates(accumulation);
    await Future.wait(states.map((state) => entityInflater.initializeState(state)));

    final records = states.map((state) => Entity.fromState(state)).cast<R>().toList();
    await Future.wait(records.map((value) => entityInflater.inflateEntity(value as Entity)));

    return records;
  }
}
