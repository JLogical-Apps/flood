import 'package:cloud_firestore/cloud_firestore.dart' as firebase;
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_cloud_repository.dart';
import 'package:firebase/src/drop/firebase_query_reducer.dart';
import 'package:firebase/src/drop/firebase_query_request_reducer.dart';
import 'package:firebase/src/drop/query/from_firebase_query_reducer.dart';
import 'package:firebase/src/drop/query/limit_firebase_query_reducer.dart';
import 'package:firebase/src/drop/query/order_by_firebase_query_reducer.dart';
import 'package:firebase/src/drop/query/where_firebase_query_reducer.dart';
import 'package:firebase/src/drop/request/all_states_firebase_query_request_reducer.dart';
import 'package:firebase/src/drop/request/first_or_null_state_firebase_query_request_reducer.dart';
import 'package:firebase/src/drop/request/map_firebase_query_request_reducer.dart';
import 'package:firebase/src/drop/request/paginate_states_firebase_query_request_reducer.dart';
import 'package:firebase/src/drop/request/wrapper_firebase_query_request_reducer.dart';
import 'package:log_core/log_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:runtime_type/type.dart';
import 'package:utils/utils.dart';

class FirebaseCloudRepositoryQueryExecutor with IsRepositoryQueryExecutor {
  final FirebaseCloudRepository repository;

  FirebaseCloudRepositoryQueryExecutor({required this.repository});

  DropCoreContext get dropContext => repository.context.dropCoreComponent;

  RuntimeType? get inferredType => repository.handledTypes.length == 1 ? repository.handledTypes[0] : null;

  ModifierResolver<FirebaseQueryReducer, Query> getQueryReducerResolver() => Resolver.fromModifiers([
        FromFirebaseQueryReducer(
          context: repository.context.dropCoreComponent,
          rootPath: repository.rootPath,
          inferredType: inferredType,
        ),
        LimitFirebaseQueryReducer(),
        OrderByFirebaseQueryReducer(),
        WhereFirebaseQueryReducer(),
      ]);

  ModifierResolver<FirebaseQueryRequestReducer, QueryRequest> getQueryRequestReducerResolver<T>() =>
      Resolver.fromModifiers([
        AllStatesFirebaseQueryRequestReducer(dropContext: dropContext, inferredType: inferredType),
        FirstOrNullStateFirebaseQueryRequestReducer(dropContext: dropContext, inferredType: inferredType),
        MapFirebaseQueryRequestReducer(
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
        PaginateStatesFirebaseQueryRequestReducer(
          dropContext: dropContext,
          inferredType: inferredType,
        ),
        WrapperFirebaseQueryRequestReducer(
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
  Future<T> onExecuteQuery<T>(QueryRequest<dynamic, T> queryRequest, {Function(State state)? onStateRetreived}) async {
    repository.context.log('Executing query to Firebase: [$queryRequest]');
    final firestoreQuery = reduceQuery(null, queryRequest.query);
    return await getQueryRequestReducerResolver().resolve(queryRequest).reduce(
          queryRequest,
          firestoreQuery,
          onStateRetrieved: onStateRetreived,
        );
  }

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<T>(
    QueryRequest<dynamic, T> queryRequest, {
    Function(State state)? onStateRetreived,
  }) {
    repository.context.log('Executing queryX to Firebase: [$queryRequest]');
    final firestoreQuery = reduceQuery(null, queryRequest.query);
    return getQueryRequestReducerResolver()
        .resolve(queryRequest)
        .reduceX(queryRequest, firestoreQuery, onStateRetrieved: onStateRetreived)
        .map<FutureValue<T>>((result) => FutureValue.loaded(result))
        .publishValueSeeded(FutureValue.loading())
        .autoConnect();
  }

  firebase.Query reduceQuery(firebase.Query? firestoreQuery, Query query) {
    final queryParent = query.parent;
    return getQueryReducerResolver()
        .resolve(query)
        .reduce(query, queryParent == null ? firestoreQuery : reduceQuery(firestoreQuery, queryParent));
  }

  Future<T> resolveForQueryRequest<T>(
    QueryRequest<dynamic, T> queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetreived,
  }) async {
    return await getQueryRequestReducerResolver<T>().resolve(queryRequest).reduce(
          queryRequest,
          firestoreQuery,
          onStateRetrieved: onStateRetreived,
        );
  }

  Stream<T> resolveForQueryRequestX<T>(
    QueryRequest<dynamic, T> queryRequest,
    firebase.Query firestoreQuery, {
    Function(State state)? onStateRetreived,
  }) {
    return getQueryRequestReducerResolver<T>()
        .resolve(queryRequest)
        .reduceX(
          queryRequest,
          firestoreQuery,
          onStateRetrieved: onStateRetreived,
        )
        .cast<T>();
  }
}
