import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/persistence/firestore_document_data_source.dart';
import 'package:firebase/src/persistence/firestore_document_raw_data_source.dart';
import 'package:firebase/src/persistence/firestore_document_state_data_source.dart';
import 'package:persistence/persistence.dart';
import 'package:runtime_type/type.dart';

extension DataSourceStaticExtension on DataSourceStatic {
  FirestoreDocumentRawDataSource firestoreDocumentRaw(String path) => FirestoreDocumentRawDataSource(path: path);

  FirestoreDocumentDataSource firestoreDocument(String path) => FirestoreDocumentDataSource(path: path);

  FirestoreDocumentStateDataSource firestoreDocumentState(
    String path, {
    required DropCoreContext context,
    required RuntimeType stateType,
  }) =>
      FirestoreDocumentStateDataSource(
        path: path,
        context: context,
        stateType: stateType,
      );

  DataSource<E> firestoreDocumentEntity<E extends Entity>(String path, {required DropCoreContext context}) =>
      firestoreDocumentState(
        path,
        context: context,
        stateType: context.typeContext.getRuntimeType<E>(),
      ).mapEntity(context);
}
