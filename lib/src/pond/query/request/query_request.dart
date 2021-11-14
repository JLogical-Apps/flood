import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/utils/marker.dart';

@marker
abstract class QueryRequest<R extends Record, T> {
  final Query<R> query;

  const QueryRequest({required this.query});

  List<Query> getQueryChain() {
    var queries = <Query>[];
    Query? _query = query;
    while (_query != null) {
      queries.add(_query);
      _query = _query.parent;
    }

    return queries.reversed.toList();
  }
}