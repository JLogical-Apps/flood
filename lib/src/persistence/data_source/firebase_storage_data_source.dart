import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../pond/modules/logging/default_logging_module.dart';
import 'data_source.dart';

class FirebaseStorageDataSource extends DataSource<Uint8List> {
  final String storagePath;

  FirebaseStorageDataSource({required this.storagePath});

  Reference get storageReference => FirebaseStorage.instance.ref(storagePath);

  @override
  Future<Uint8List?> getData() async {
    logWarning('Getting data from Firebase Storage: $storagePath');
    return await storageReference.getData();
  }

  @override
  Future<void> saveData(Uint8List data) {
    logWarning('Saving data to Firebase Storage: $storagePath');
    return storageReference.putData(data);
  }

  @override
  Future<void> delete() {
    logWarning('Deleting from Firebase Storage: $storagePath');
    return storageReference.delete();
  }
}
