import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/condition/query_condition.dart';
import 'package:drop_core/src/query/from_query.dart';
import 'package:drop_core/src/query/limit_query.dart';
import 'package:drop_core/src/query/order_by_query.dart';
import 'package:drop_core/src/query/query_where_builder.dart';
import 'package:drop_core/src/query/request/all_query_request.dart';
import 'package:drop_core/src/query/request/all_states_query_request.dart';
import 'package:drop_core/src/query/request/count_query_request.dart';
import 'package:drop_core/src/query/request/first_or_null_query_request.dart';
import 'package:drop_core/src/query/request/first_or_null_state_query_request.dart';
import 'package:drop_core/src/query/request/first_query_request.dart';
import 'package:drop_core/src/query/request/paginate_query_request.dart';
import 'package:drop_core/src/query/request/paginate_states_query_request.dart';
import 'package:drop_core/src/query/request/query_request.dart';
import 'package:drop_core/src/query/where_query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:equatable/equatable.dart';

abstract class Query<E extends Entity> with EquatableMixin {
  final Query? parent;

  Query({required this.parent});

  static QueryRequest<E, E?> getByIdOrNull<E extends Entity>(String id) {
    return Query.from<E>().where(State.idField).isEqualTo(id).firstOrNull();
  }

  static QueryRequest<E, E> getById<E extends Entity>(String id) {
    return Query.from<E>().where(State.idField).isEqualTo(id).first();
  }

  static QueryRequest<Entity, Entity?> getByIdOrNullRuntime(Type entityType, String id) {
    return Query.fromRuntime(entityType).where(State.idField).isEqualTo(id).firstOrNull();
  }

  static QueryRequest<Entity, Entity> getByIdRuntime(Type entityType, String id) {
    return Query.fromRuntime(entityType).where(State.idField).isEqualTo(id).first();
  }

  static FromQuery<E> from<E extends Entity>() {
    return FromQuery<E>(entityType: E);
  }

  static FromQuery fromRuntime(Type entityType) {
    return FromQuery(entityType: entityType);
  }

  static FromQuery<Entity> fromAll() {
    return from();
  }

  String prettyPrint(DropCoreContext context);
}

extension QueryExtensions<E extends Entity> on Query<E> {
  AllStatesQueryRequest allStates() {
    return AllStatesQueryRequest(query: this);
  }

  AllQueryRequest<E> all() {
    return AllQueryRequest(sourceQueryRequest: AllStatesQueryRequest(query: this));
  }

  FirstOrNullStateQueryRequest<E> firstOrNullState() {
    return FirstOrNullStateQueryRequest(query: this);
  }

  FirstOrNullQueryRequest<E> firstOrNull() {
    return FirstOrNullQueryRequest(sourceQueryRequest: FirstOrNullStateQueryRequest(query: this));
  }

  FirstQueryRequest<E> first() {
    return FirstQueryRequest(sourceQueryRequest: FirstOrNullStateQueryRequest(query: this));
  }

  CountQueryRequest<E> count() {
    return CountQueryRequest(query: this);
  }

  QueryWhereBuilder<E> where(String stateField) {
    return QueryWhereBuilder(query: this, stateField: stateField);
  }

  WhereQuery<E> whereCondition(QueryCondition condition) {
    return WhereQuery(parent: this, condition: condition);
  }

  OrderByQuery<E> orderBy(String stateField, {required OrderByType type}) {
    return OrderByQuery(parent: this, stateField: stateField, type: type);
  }

  OrderByQuery<E> orderByDescending(String stateField) {
    return orderBy(stateField, type: OrderByType.descending);
  }

  OrderByQuery<E> orderByAscending(String stateField) {
    return orderBy(stateField, type: OrderByType.ascending);
  }

  LimitQuery<E> limit(int limit) {
    return LimitQuery(parent: this, limit: limit);
  }

  PaginateStatesQueryRequest paginateStates({int pageSize = 20}) {
    return PaginateStatesQueryRequest(query: this, pageSize: pageSize);
  }

  PaginatedQueryRequest<E> paginate({int pageSize = 20}) {
    return PaginatedQueryRequest<E>(sourceQueryRequest: PaginateStatesQueryRequest(query: this, pageSize: pageSize));
  }

  Query get root {
    Query root = this;
    while (root.parent != null) {
      root = root.parent!;
    }
    return root;
  }
}
