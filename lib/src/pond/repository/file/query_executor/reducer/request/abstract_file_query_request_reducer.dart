import 'package:jlogical_utils/src/pond/query/reducer/request/abstract_sync_query_reducer.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

abstract class AbstractFileQueryRequestReducer<QR extends QueryRequest<R, T>, R extends Record, T>
    extends AbstractSyncQueryRequestReducer<QR, R, T, Iterable<Record>> {}
