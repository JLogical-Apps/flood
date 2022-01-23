import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_without_cache_query_reducer.dart';

class FirestoreWithoutCacheQueryReducer extends AbstractWithoutCacheQueryReducer<firestore.Query> {
  @override
  Future<firestore.Query> reduce({required firestore.Query? accumulation, required Query query}) async {
    // The query itself doesn't do anything.
    return accumulation!;
  }
}
