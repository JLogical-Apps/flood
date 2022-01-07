import 'package:jlogical_utils/src/pond/query/order_by_query.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/query/reducer/query/abstract_order_by_query_reducer.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';

class LocalOrderByQueryReducer extends AbstractOrderByQueryReducer<Iterable<Record>> {
  @override
  Future<Iterable<Record>> reduce({required Iterable<Record>? accumulation, required Query query}) async {
    final orderByQuery = query as OrderByQuery;
    final orderByType = orderByQuery.orderByType;
    final sortField = orderByQuery.fieldName;

    final multiplier = orderByType == OrderByType.ascending ? 1 : -1;
    final list = accumulation!.toList();
    list.sort((a, b) => _compare(a, b, sortField) * multiplier);
    return list;
  }

  int _compare(Record a, Record b, String sortField) {
    final valueA = a.state[sortField];
    final valueB = b.state[sortField];

    if ((valueA is Comparable?) && (valueB is Comparable?)) {
      if (valueA == null && valueB == null) {
        return 0;
      }

      if (valueA == null) {
        return -valueB!.compareTo(valueA);
      }

      return valueA.compareTo(valueB);
    }

    throw Exception('Cannot sort values [$valueA] and [$valueB]');
  }
}
