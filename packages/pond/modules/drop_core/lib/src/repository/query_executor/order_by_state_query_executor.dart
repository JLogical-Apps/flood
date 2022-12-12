import 'package:drop_core/src/query/order_by_query.dart';
import 'package:drop_core/src/repository/query_executor/state_query_reducer.dart';
import 'package:drop_core/src/state/state.dart';

class OrderByStateQueryReducer extends StateQueryReducer<OrderByQuery> {
  @override
  Iterable<State> reduce(OrderByQuery query, Iterable<State> currentStates) {
    return currentStates.toList()..sort((a, b) => order(query, a, b));
  }

  int order(OrderByQuery query, State a, State b) {
    final aValue = a[query.stateField];
    final bValue = b[query.stateField];

    if (aValue == null && bValue == null) {
      return 0;
    }

    if (aValue == null) {
      return 1;
    }

    if (bValue == null) {
      return -1;
    }

    var compare = aValue.compareTo(bValue);
    if (query.type == OrderByType.descending) {
      compare *= -1;
    }

    return compare;
  }
}
