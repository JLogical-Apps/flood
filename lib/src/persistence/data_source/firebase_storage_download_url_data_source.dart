import 'package:firebase_storage/firebase_storage.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class FirebaseStorageDownloadUrlDataSource extends DataSource<String> {
  final String storagePath;

  FirebaseStorageDownloadUrlDataSource({required this.storagePath});

  Reference get storageReference => FirebaseStorage.instance.ref(storagePath);

  @override
  Future<String?> getData() async {
    return await storageReference.getDownloadURL();
  }

  @override
  Future<void> saveData(String data) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }
}
