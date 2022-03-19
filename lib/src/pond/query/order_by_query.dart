import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/request/all_query_request.dart';
import 'package:jlogical_utils/src/pond/query/request/query_request.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class OrderByQuery<R extends Record> extends Query<R> {
  final String fieldName;
  final OrderByType orderByType;

  OrderByQuery({required Query parent, required this.fieldName, this.orderByType: OrderByType.ascending})
      : super(parent: parent);

  @override
  List<Object?> get queryProps => [fieldName, orderByType];

  @override
  bool mustBePresentInSuperQuery(QueryRequest queryRequest) {
    // If the query request gets all records, then it's fine if it didn't get them ordered
    // since ordering will be done locally.
    if (queryRequest is AllQueryRequest) {
      return false;
    }

    // Otherwise, return true since `.firstOrNull()` is not a super-query of
    // `.orderByAscending(prop).firstOrNull()`.
    return true;
  }

  @override
  String toString() {
    return '$parent | order by $fieldName $orderByType';
  }
}

enum OrderByType {
  ascending,
  descending,
}
