import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/order_by_query.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_order_by_query_reducer.dart';

class FirestoreOrderByQueryReducer extends AbstractOrderByQueryReducer<firestore.Query> {
  @override
  Future<firestore.Query> reduce({required firestore.Query? accumulation, required Query query}) async {
    final orderByQuery = query as OrderByQuery;
    final orderByType = orderByQuery.orderByType;

    return accumulation!.orderBy(orderByQuery.fieldName, descending: orderByType == OrderByType.descending);
  }
}
