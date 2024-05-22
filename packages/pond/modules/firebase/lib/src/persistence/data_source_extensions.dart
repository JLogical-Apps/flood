import 'dart:typed_data';

import 'package:asset/asset.dart';
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/persistence/firebase_storage_asset_data_source.dart';
import 'package:firebase/src/persistence/firebase_storage_data_source.dart';
import 'package:firebase/src/persistence/firebase_storage_download_url_data_source.dart';
import 'package:firebase/src/persistence/firebase_storage_metadata_data_source.dart';
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

  DataSource<Asset> firebaseStorageAsset({required CorePondContext context, required String path}) =>
      FirebaseStorageAssetDataSource(context: context, path: path);

  DataSource<Uint8List> firebaseStorage({required CorePondContext context, required String path}) =>
      FirebaseStorageDataSource(context: context, path: path);

  DataSource<AssetMetadata> firebaseStorageMetadata({required CorePondContext context, required String path}) =>
      FirebaseStorageMetadataDataSource(context: context, path: path);

  DataSource<String> firebaseDownloadUrl({required CorePondContext context, required String path}) =>
      FirebaseStorageDownloadUrlDataSource(context: context, path: path);
}
