
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_without_cache_query_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class FileWithoutCacheQueryReducer extends AbstractWithoutCacheQueryReducer<Iterable<Record>> {
  @override
  Future<Iterable<Record>> reduce({required Iterable<Record>? accumulation, required Query query}) async {
    // The query itself doesn't do anything.
    return accumulation!;
  }
}
