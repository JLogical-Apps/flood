import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'data_source.dart';

class FirebaseStorageDataSource extends DataSource<Uint8List> {
  final String storagePath;

  FirebaseStorageDataSource({required this.storagePath});

  Reference get storageReference => FirebaseStorage.instance.ref(storagePath);

  @override
  Future<Uint8List?> getData() async {
    return await storageReference.getData();
  }

  @override
  Future<void> saveData(Uint8List data) {
    return storageReference.putData(data);
  }

  @override
  Future<void> delete() {
    return storageReference.delete();
  }
}
