import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/from_query_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalFromQueryReducer extends FromQueryReducer<Iterable<Record>> {
  final Map<String, Record> recordById;

  const LocalFromQueryReducer({required this.recordById});

  @override
  Iterable<Record> reduce({required Iterable<Record>? aggregate, required Query query}) {
    return recordById.entries.where((entry) => entry.value.runtimeType == query.recordType).map((entry) => entry.value);
  }
}
