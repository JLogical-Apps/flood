import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_query_request_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractFirestoreQueryRequestReducer<QR extends QueryRequest<R, T>, R extends Record, T>
    extends AbstractQueryRequestReducer<QR, R, T, firestore.Query> {}
