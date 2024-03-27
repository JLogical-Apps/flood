import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistence/persistence.dart';

class FirestoreDocumentRawDataSource with IsDataSource<DocumentSnapshot> {
  final String path;

  late DocumentReference documentReference = FirebaseFirestore.instance.doc(path);

  FirestoreDocumentRawDataSource({required this.path});

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
