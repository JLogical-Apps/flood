import 'dart:async';

import 'package:drop_core/drop_core.dart';
import 'package:log_core/log_core.dart';
import 'package:ops/src/appwrite/drop/appwrite_cloud_repository.dart';
import 'package:ops/src/appwrite/drop/appwrite_query.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_reducer.dart';
import 'package:ops/src/appwrite/drop/appwrite_query_request_reducer.dart';
import 'package:ops/src/appwrite/drop/query/from_appwrite_query_reducer.dart';
import 'package:ops/src/appwrite/drop/query/limit_appwrite_query_reducer.dart';
import 'package:ops/src/appwrite/drop/query/order_by_appwrite_query_reducer.dart';
import 'package:ops/src/appwrite/drop/query/where_appwrite_query_reducer.dart';
import 'package:ops/src/appwrite/drop/request/all_states_appwrite_query_request_reducer.dart';
import 'package:ops/src/appwrite/drop/request/first_or_null_state_appwrite_query_request_reducer.dart';
import 'package:ops/src/appwrite/drop/request/map_appwrite_query_request_reducer.dart';
import 'package:ops/src/appwrite/drop/request/paginate_states_appwrite_query_request_reducer.dart';
import 'package:ops/src/appwrite/drop/request/wrapper_appwrite_query_request_reducer.dart';
import 'package:runtime_type/type.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class AppwriteCloudRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final AppwriteCloudRepository repository;

  AppwriteCloudRepositoryQueryExecutor({required this.repository});

  DropCoreContext get dropContext => repository.context.dropCoreComponent;

  RuntimeType? get inferredType => repository.handledTypes.length == 1 ? repository.handledTypes[0] : null;

  ModifierResolver<AppwriteQueryReducer, Query> getQueryReducerResolver() => Resolver.fromModifiers([
        FromAppwriteQueryReducer(
          context: repository.context.dropCoreComponent,
          rootPath: repository.rootPath,
          inferredType: inferredType,
        ),
        LimitAppwriteQueryReducer(),
        OrderByAppwriteQueryReducer(),
        WhereAppwriteQueryReducer(),
      ]);

  ModifierResolver<AppwriteQueryRequestReducer, QueryRequest> getQueryRequestReducerResolver<T>() =>
      Resolver.fromModifiers([
        AllStatesAppwriteQueryRequestReducer(dropContext: dropContext, inferredType: inferredType),
        FirstOrNullStateAppwriteQueryRequestReducer(dropContext: dropContext, inferredType: inferredType),
        MapAppwriteQueryRequestReducer(
          dropContext: dropContext,
          inferredType: inferredType,
          queryRequestResolver: <T>(qr, states, onStateRetrieved) => resolveForQueryRequest(
            qr,
            states,
            onStateRetreived: onStateRetrieved,
          ),
          queryRequestResolverX: <T>(qr, states, onStateRetrieved) => resolveForQueryRequestX(
            qr,
            states,
            onStateRetreived: onStateRetrieved,
          ),
        ),
        PaginateStatesAppwriteQueryRequestReducer(
          dropContext: dropContext,
          inferredType: inferredType,
        ),
        WrapperAppwriteQueryRequestReducer(
          dropContext: dropContext,
          inferredType: inferredType,
          queryRequestResolver: <T>(qr, states, onStateRetrieved) => resolveForQueryRequest(
            qr,
            states,
            onStateRetreived: onStateRetrieved,
          ),
          queryRequestResolverX: <T>(qr, states, onStateRetrieved) => resolveForQueryRequestX(
            qr,
            states,
            onStateRetreived: onStateRetrieved,
          ),
        ),
      ]);

  @override
  Future<T> onExecuteQuery<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) async {
    repository.context.log('Executing query to Appwrite: [${queryRequest.prettyPrint(dropContext)}]');
    final appwriteQuery = reduceQuery(null, queryRequest.query);
    return await getQueryRequestReducerResolver().resolve(queryRequest).reduce(
          queryRequest,
          appwriteQuery,
          onStateRetrieved: onStateRetreived,
        );
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    repository.context.log('Executing queryX to Appwrite: [${queryRequest.prettyPrint(dropContext)}]');
    final appwriteQuery = reduceQuery(null, queryRequest.query);
    return getQueryRequestReducerResolver()
        .resolve(queryRequest)
        .reduceX(queryRequest, appwriteQuery, onStateRetrieved: onStateRetreived)
        .map<FutureValue<T>>((result) => FutureValue.loaded(result))
        .publishValueSeeded(FutureValue.loading())
        .autoConnect();
  }

  AppwriteQuery reduceQuery(AppwriteQuery? appwriteQuery, Query query) {
    final queryParent = query.parent;
    return getQueryReducerResolver()
        .resolve(query)
        .reduce(query, queryParent == null ? appwriteQuery : reduceQuery(appwriteQuery, queryParent));
  }

  Future<T> resolveForQueryRequest<E extends Entity, T>(
    QueryRequest<E, T> queryRequest,
    AppwriteQuery appwriteQuery, {
    FutureOr Function(State state)? onStateRetreived,
  }) async {
    return await getQueryRequestReducerResolver<T>().resolve(queryRequest).reduce(
          queryRequest,
          appwriteQuery,
          onStateRetrieved: onStateRetreived,
        );
  }

  Stream<T> resolveForQueryRequestX<E extends Entity, T>(
    QueryRequest<E, T> queryRequest,
    AppwriteQuery appwriteQuery, {
    FutureOr Function(State state)? onStateRetreived,
  }) {
    return getQueryRequestReducerResolver<T>()
        .resolve(queryRequest)
        .reduceX(
          queryRequest,
          appwriteQuery,
          onStateRetrieved: onStateRetreived,
        )
        .cast<T>();
  }
}
