import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A response to a query with a list. Also stores a cursor that can be used to retrieve more results.
/// [R] is the type of the data.
/// [C] is the type of the cursor.
class QueryListResponse<R, C> extends Equatable {
  /// The data retrieved from the response.
  final List<R> data;

  /// The cursor that will retrieve the next set of items.
  final C cursor;

  const QueryListResponse({@required this.data, @required this.cursor});

  @override
  List<Object> get props => [data, cursor];
}
