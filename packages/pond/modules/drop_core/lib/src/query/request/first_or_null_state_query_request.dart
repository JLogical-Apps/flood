import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/state/state.dart';

class FirstOrNullStateQueryRequest extends QueryRequest<State?> {
  @override
  final Query query;

  FirstOrNullStateQueryRequest({required this.query});

  @override
  String toString() {
    return '$query | first?';
  }

  @override
  List<Object?> get props => [query];
}
