import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/from_query.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_sync_query_reducer.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class LocalFromQueryReducer extends AbstractSyncQueryReducer<FromQuery, Iterable<State>> {
  final Map<String, State> stateById;

  const LocalFromQueryReducer({required this.stateById});

  @override
  Iterable<State> reduceSync({required Iterable<State>? accumulation, required Query query}) {
    final descendants = AppContext.global.getDescendants(query.recordType);
    final types = {...descendants, query.recordType};
    final typeNames = types.map((type) => type.toString()).toList();
    return stateById.values.where((state) => typeNames.contains(state.type));
  }
}
