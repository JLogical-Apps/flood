import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/utils/marker.dart';

@marker
abstract class AbstractQueryRequest<R extends Record, T> {
  final Transaction? transaction;

  /// The query that this request makes a request on.
  Query<R> get query;

  const AbstractQueryRequest({this.transaction});

  Type get outputType => T;
}
