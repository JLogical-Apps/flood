import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class FileWithoutCacheQueryReducer extends AbstractQueryReducer<WithoutCacheQuery, Iterable<State>> {
  @override
  Future<Iterable<State>> reduce({required Iterable<State>? accumulation, required Query query}) async {
    // The query itself doesn't do anything.
    return accumulation!;
  }
}
