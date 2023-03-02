import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';

class FirstOrNullStateQueryRequest<E extends Entity> extends QueryRequest<E, State?> {
  @override
  final Query<E> query;

  FirstOrNullStateQueryRequest({required this.query});

  @override
  String toString() {
    return '$query | first?';
  }

  @override
  List<Object?> get props => [query];
}
