import 'package:asset/asset.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:persistence/persistence.dart';
import 'package:pond_core/pond_core.dart';

class FirebaseStorageMetadataDataSource with IsDataSource<AssetMetadata> {
  final CorePondContext context;
  final String path;

  late Reference reference = context.firebaseCoreComponent.storage.ref(path);

  FirebaseStorageMetadataDataSource({required this.context, required this.path});

  @override
  Stream<AssetMetadata> getXOrNull() async* {
    yield await getOrNull();
  }

  @override
  Future<AssetMetadata> getOrNull() async {
    final firebaseMetadata = await reference.getMetadata();
    final downloadUrl = await reference.getDownloadURL();
    return AssetMetadata(
      createdTime: firebaseMetadata.timeCreated ?? DateTime.now(),
      updatedTime: firebaseMetadata.updated ?? DateTime.now(),
      size: firebaseMetadata.size ?? -1,
      mimeType: firebaseMetadata.contentType ?? lookupMimeType(path),
      uri: Uri.parse(downloadUrl),
    );
  }

  @override
  Future<void> set(AssetMetadata data) async {
    await reference.updateMetadata(SettableMetadata(contentType: data.mimeType));
  }

  @override
  Future<void> delete() async {
    throw Exception('Cannot delete metadata from Firebase Storage!');
  }
}
