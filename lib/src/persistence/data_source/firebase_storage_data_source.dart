import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../pond/modules/logging/default_logging_module.dart';
import '../ids/uuid_id_generator.dart';
import 'data_source.dart';

class FirebaseStorageDataSource extends DataSource<Uint8List> {
  final String storagePath;

  FirebaseStorageDataSource({required this.storagePath});

  Reference get storageReference => FirebaseStorage.instance.ref(storagePath);

  @override
  Future<Uint8List?> getData() async {
    logWarning('Getting data from Firebase Storage: $storagePath');

    final file = Directory.systemTemp - '${UuidIdGenerator().getId()}.tmp';
    await storageReference.writeToFile(file);

    final data = await file.readAsBytes();
    await file.delete();

    return data;
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

  @override
  Future<bool> exists() async {
    final downloadUrl = await guardAsync(() => storageReference.getDownloadURL());
    return downloadUrl != null;
  }
}
