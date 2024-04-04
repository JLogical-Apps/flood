import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:persistence/persistence.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreDocumentDataSource with IsDataSource<Map<String, dynamic>> {
  final String path;

  late DocumentReference documentReference = FirebaseFirestore.instance.doc(path);

  FirestoreDocumentDataSource({required this.path});

  @override
  Stream<Map<String, dynamic>>? getXOrNull() {
    return documentReference.snapshots().map((snapshot) => snapshot.data() as Map<String, dynamic>?).whereNotNull();
  }

  @override
  Future<Map<String, dynamic>?> getOrNull() async {
    return (await documentReference.get()).data() as Map<String, dynamic>?;
  }

  @override
  Future<void> set(Map<String, dynamic> data) async {
    await documentReference.set(data, SetOptions(merge: true));
  }

  @override
  Future<void> delete() async {
    await documentReference.delete();
  }
}
