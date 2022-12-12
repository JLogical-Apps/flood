import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/order_by_query.dart';
import 'package:drop_core/src/query/query_where_builder.dart';
import 'package:drop_core/src/query/request/all_query_request.dart';
import 'package:drop_core/src/query/request/all_states_query_request.dart';
import 'package:drop_core/src/query/request/first_or_null_query_request.dart';
import 'package:drop_core/src/query/request/first_or_null_state_query_request.dart';
import 'package:drop_core/src/query/request/first_query_request.dart';
import 'package:drop_core/src/query/where_query.dart';

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

  QueryWhereBuilder where(String stateField) {
    return QueryWhereBuilder(query: this, stateField: stateField);
  }

  WhereQuery whereCondition(QueryCondition condition) {
    return WhereQuery(parent: this, condition: condition);
  }

  OrderByQuery orderBy(String stateField, {required OrderByType type}) {
    return OrderByQuery(parent: this, stateField: stateField, type: type);
  }

  OrderByQuery orderByDescending(String stateField) {
    return orderBy(stateField, type: OrderByType.descending);
  }

  OrderByQuery orderByAscending(String stateField) {
    return orderBy(stateField, type: OrderByType.ascending);
  }
}
