import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:persistence/persistence.dart';
import 'package:pond_core/pond_core.dart';

class FirebaseStorageDownloadUrlDataSource with IsDataSource<String> {
  final CorePondContext context;
  final String path;

  late Reference reference = context.firebaseCoreComponent.storage.ref(path);

  FirebaseStorageDownloadUrlDataSource({required this.context, required this.path});

  @override
  Stream<String> getXOrNull() async* {
    yield await getOrNull();
  }

  @override
  Future<String> getOrNull() async {
    return await reference.getDownloadURL();
  }

  @override
  Future<void> set(String data) async {
    throw Exception('Cannot set download url of Firebase Storage!');
  }

  @override
  Future<void> delete() async {
    throw Exception('Cannot delete download url of Firebase Storage!');
  }
}
