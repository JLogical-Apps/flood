import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/request/all_query_request.dart';
import 'package:drop_core/src/query/request/all_states_query_request.dart';

abstract class Query<E extends Entity> {
  final Query<E>? parent;

  Query({required this.parent});

  static FromQuery<E> from<E extends Entity>() {
    return FromQuery<E>();
  }
}

extension QueryExtensions<E extends Entity> on Query<E> {
  AllQueryRequest<E> all() {
    return AllQueryRequest(query: this);
  }

  AllStatesQueryRequest<E> allStates() {
    return AllStatesQueryRequest(query: this);
  }
}
