import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/src/utils/firebase_context_extensions.dart';
import 'package:persistence/persistence.dart';
import 'package:pond/pond.dart';

class FirestoreDocumentRawDataSource with IsDataSource<DocumentSnapshot> {
  final CorePondContext context;
  final String path;

  late DocumentReference documentReference = context.firebaseCoreComponent.firestore.doc(path);

  FirestoreDocumentRawDataSource({required this.context, required this.path});

  @override
  Stream<DocumentSnapshot>? getXOrNull() {
    return documentReference.snapshots();
  }

  @override
  Future<DocumentSnapshot?> getOrNull() async {
    return await documentReference.get();
  }

  @override
  Future<void> set(DocumentSnapshot data) {
    throw Exception('Cannot set the data of a FirestoreDocumentRawDataSource!');
  }

  @override
  Future<void> delete() async {
    await documentReference.delete();
  }
}
