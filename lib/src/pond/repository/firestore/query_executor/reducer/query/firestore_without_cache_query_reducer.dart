import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/without_cache_query.dart';

class FirestoreWithoutCacheQueryReducer extends AbstractQueryReducer<WithoutCacheQuery, firestore.Query> {
  @override
  Future<firestore.Query> reduce({required firestore.Query? accumulation, required Query query}) async {
    // The query itself doesn't do anything.
    return accumulation!;
  }
}
