import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/request/all_query_request.dart';
import 'package:drop_core/src/query/request/all_states_query_request.dart';

abstract class Query {
  final Query? parent;

  Query({required this.parent});

  static FromQuery from<E extends Entity>() {
    return FromQuery(entityType: E);
  }
}

extension QueryExtensions on Query {
  AllQueryRequest<E> all<E extends Entity>() {
    return AllQueryRequest(sourceQueryRequest: AllStatesQueryRequest(query: this));
  }

  AllStatesQueryRequest allStates() {
    return AllStatesQueryRequest(query: this);
  }
}
