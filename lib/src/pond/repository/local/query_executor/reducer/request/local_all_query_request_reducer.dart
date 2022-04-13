import 'package:jlogical_utils/src/pond/query/reducer/entity_inflater.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

import '../../../../../record/entity.dart';
import 'abstract_local_query_request_reducer.dart';

class LocalAllQueryRequestReducer<R extends Record>
    extends AbstractLocalQueryRequestReducer<AllQueryRequest<R>, R, List<R>> {
  final EntityInflater entityInflater;

  LocalAllQueryRequestReducer({required this.entityInflater});

  @override
  List<R> reduceSync({
    required Iterable<State> accumulation,
    required AllQueryRequest<R> queryRequest,
  }) {
    return accumulation.map((state) => Entity.fromState(state)).cast<R>().toList();
  }

  @override
  Future<List<R>> inflate(List<R> output) async {
    final newStates = await Future.wait(output.map((entity) async {
      final state = entity.state;
      await entityInflater.initializeState(state);
      return state;
    }));

    final newOutput = newStates.map((state) => Entity.fromState(state)).cast<R>().toList();
    await Future.wait(newOutput.map((value) => entityInflater.inflateEntity(value as Entity)));
    return newOutput;
  }
}
