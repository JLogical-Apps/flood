import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/persistence/firestore_document_data_source.dart';
import 'package:firebase/src/persistence/firestore_document_raw_data_source.dart';
import 'package:firebase/src/persistence/firestore_document_state_data_source.dart';
import 'package:persistence/persistence.dart';
import 'package:pond_core/pond_core.dart';
import 'package:runtime_type/type.dart';

extension DataSourceStaticExtension on DataSourceStatic {
  FirestoreDocumentRawDataSource firestoreDocumentRaw(
    String path, {
    required CorePondContext context,
  }) =>
      FirestoreDocumentRawDataSource(context: context, path: path);

  FirestoreDocumentDataSource firestoreDocument(
    String path, {
    required CorePondContext context,
  }) =>
      FirestoreDocumentDataSource(context: context, path: path);

  FirestoreDocumentStateDataSource firestoreDocumentState(
    String path, {
    required CorePondContext context,
    required RuntimeType stateType,
  }) =>
      FirestoreDocumentStateDataSource(
        path: path,
        context: context,
        stateType: stateType,
      );

  DataSource<E> firestoreDocumentEntity<E extends Entity>(String path, {required CorePondContext context}) =>
      firestoreDocumentState(
        path,
        context: context,
        stateType: context.dropCoreComponent.getRuntimeType<E>(),
      ).mapEntity(context.dropCoreComponent);
}
