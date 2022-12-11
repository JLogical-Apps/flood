import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/request/all_query_request.dart';
import 'package:drop_core/src/query/request/all_states_query_request.dart';
import 'package:drop_core/src/query/request/first_or_null_query_request.dart';
import 'package:drop_core/src/query/request/first_or_null_state_query_request.dart';
import 'package:drop_core/src/query/request/first_query_request.dart';

abstract class Query {
  final Query? parent;

  Query({required this.parent});

  static FromQuery from<E extends Entity>() {
    return FromQuery(entityType: E);
  }
}

extension QueryExtensions on Query {
  AllStatesQueryRequest allStates() {
    return AllStatesQueryRequest(query: this);
  }

  AllQueryRequest<E> all<E extends Entity>() {
    return AllQueryRequest(sourceQueryRequest: AllStatesQueryRequest(query: this));
  }

  FirstOrNullStateQueryRequest firstOrNullState() {
    return FirstOrNullStateQueryRequest(query: this);
  }

  FirstOrNullQueryRequest<E> firstOrNull<E extends Entity>() {
    return FirstOrNullQueryRequest(sourceQueryRequest: FirstOrNullStateQueryRequest(query: this));
  }

  FirstQueryRequest<E> first<E extends Entity>() {
    return FirstQueryRequest(sourceQueryRequest: FirstOrNullStateQueryRequest(query: this));
  }
}
