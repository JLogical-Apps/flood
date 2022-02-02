import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDocumentDataSource extends DataSource<Map<String, dynamic>> {
  final String documentPath;

  FirestoreDocumentDataSource({required this.documentPath});

  DocumentReference<Map<String, dynamic>> get document => FirebaseFirestore.instance.doc(documentPath);

  @override
  Future<Map<String, dynamic>?> getData() async {
    final snap = await document.get(GetOptions(source: Source.server));
    return snap.data();
  }

  @override
  Future<void> saveData(Map<String, dynamic> data) {
    return document.set(data);
  }

  @override
  Future<void> delete() {
    return document.delete();
  }
}
