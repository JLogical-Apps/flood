import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_sync_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalWithoutCacheQueryReducer extends AbstractSyncQueryReducer<WithoutCacheQuery, Iterable<Record>> {
  @override
  Iterable<Record> reduceSync({required Iterable<Record>? accumulation, required Query query}) {
    // The query itself doesn't do anything.
    return accumulation!;
  }
}
