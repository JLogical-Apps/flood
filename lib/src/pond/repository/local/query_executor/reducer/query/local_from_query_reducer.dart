import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_from_query_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalFromQueryReducer extends AbstractFromQueryReducer<Iterable<Record>> {
  final Map<String, State> stateById;

  const LocalFromQueryReducer({required this.stateById});

  @override
  Future<Iterable<Record>> reduce({required Iterable<Record>? accumulation, required Query query}) async {
    final descendants = AppContext.global.getDescendants(query.recordType);
    final types = {...descendants, query.recordType};
    final typeNames = types.map((type) => type.toString()).toList();
    return stateById.values.where((state) => typeNames.contains(state.type)).map((state) => Entity.fromState(state));
  }
}
