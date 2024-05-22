import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:log_core/log_core.dart';
import 'package:persistence/persistence.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils/utils.dart';

class FirebaseStorageDataSource with IsDataSource<Uint8List> {
  final CorePondContext context;
  final String path;

  late Reference reference = context.firebaseCoreComponent.storage.ref(path);

  FirebaseStorageDataSource({required this.context, required this.path});

  @override
  Stream<Uint8List> getXOrNull() async* {
    yield await getOrNull();
  }

  @override
  Future<bool> exists() async {
    return await guardAsync(() => reference.getMetadata()) != null;
  }

  @override
  Future<Uint8List> getOrNull() async {
    return await reference.getData() ?? (throw Exception('Cannot get Firebase Storage data at [$path]!'));
  }

  @override
  Future<void> set(Uint8List data) async {
    context.log('Uploading data to Firebase Storage at [$path]');
    await reference.putData(data);
  }

  @override
  Future<void> delete() async {
    context.log('Deleting data from Firebase Storage at [$path]');
    await reference.delete();
  }
}
