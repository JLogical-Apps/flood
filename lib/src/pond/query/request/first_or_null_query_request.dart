import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class FirstOrNullQueryRequest<R extends Record> extends QueryRequest<R, R?> {
  final Query<R> query;

  /// Whether the order of the query request matters.
  /// This is used to know if .paginate() can be used to provide a cache for a .firstOrNull().
  /// If order matters, then .paginate() might not have the correct firstOrNull cached.
  /// If order doesn't matter though, then cache can be used.
  final bool orderMatters;

  FirstOrNullQueryRequest({required this.query, this.orderMatters: true});

  @override
  String toString() {
    return '$query | first';
  }
}
