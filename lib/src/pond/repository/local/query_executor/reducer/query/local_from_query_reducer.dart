import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_from_query_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalFromQueryReducer extends AbstractFromQueryReducer<Iterable<Record>> {
  final Map<String, State> stateById;

  const LocalFromQueryReducer({required this.stateById});

  @override
  Iterable<Record> reduce({required Iterable<Record>? aggregate, required Query query}) {
    return stateById.values
        .where((state) => state.type == query.recordType.toString())
        .map((state) => Entity.fromStateRuntimeOrNull(state: state)!);
  }
}
