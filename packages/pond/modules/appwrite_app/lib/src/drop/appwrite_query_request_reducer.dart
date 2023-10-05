import 'dart:async';

import 'package:appwrite/models.dart';
import 'package:appwrite_app/src/drop/appwrite_query.dart';
import 'package:appwrite_app/src/drop/appwrite_timestamp_state_persister_modifier.dart';
import 'package:drop_core/drop_core.dart';
import 'package:type/type.dart';
import 'package:utils/utils.dart';

abstract class AppwriteQueryRequestReducer<QR extends QueryRequest<dynamic, T>, T> extends Modifier<QueryRequest> {
  final DropCoreContext dropContext;
  final RuntimeType? inferredType;

  late StatePersister<Map<String, dynamic>> statePersister = StatePersister.json(
    context: dropContext,
    extraStatePersisterModifiers: [
      AppwriteTimestampStatePersisterModifier(),
    ],
  );

  AppwriteQueryRequestReducer({required this.dropContext, required this.inferredType});

  @override
  bool shouldModify(QueryRequest input) {
    return input is QR;
  }

  FutureOr<T> reduce(
    QR queryRequest,
    AppwriteQuery appwriteQuery, {
    required Function(State state)? onStateRetrieved,
  });

  Stream<T> reduceX(
    QR queryRequest,
    AppwriteQuery appwriteQuery, {
    required Function(State state)? onStateRetrieved,
  });

  State getStateFromDocument(Document doc) {
    final json = doc.data;
    json[State.idField] = doc.$id;
    if (inferredType != null) {
      json[State.typeField] = inferredType!;
    }

    return statePersister.inflate(json);
  }
}
