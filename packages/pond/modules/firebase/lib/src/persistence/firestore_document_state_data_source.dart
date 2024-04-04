import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/utils/firebase_context_extensions.dart';
import 'package:firebase/src/utils/firestore_document_state_persister.dart';
import 'package:persistence/persistence.dart';
import 'package:pond_core/pond_core.dart';
import 'package:runtime_type/type.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreDocumentStateDataSource with IsDataSource<State> {
  final CorePondContext context;
  final String path;
  final RuntimeType stateType;

  late DocumentReference documentReference = context.firebaseCoreComponent.firestore.doc(path);
  late StatePersister<Map<String, dynamic>> statePersister = getDocumentSnapshotPersister(context.dropCoreComponent);

  FirestoreDocumentStateDataSource({required this.context, required this.path, required this.stateType});

  @override
  Stream<State>? getXOrNull() {
    return documentReference.snapshots().map((snapshot) => _snapshotToState(snapshot)).whereNotNull();
  }

  @override
  Future<State?> getOrNull() async {
    return _snapshotToState(await documentReference.get());
  }

  @override
  Future<void> set(State data) async {
    final json = statePersister.persist(data);

    json.remove(State.idField);

    if (data.type == stateType) {
      json.remove(State.typeField);
    }

    documentReference.set(json, SetOptions(merge: true));
  }

  @override
  Future<void> delete() async {
    await documentReference.delete();
  }

  State? _snapshotToState(DocumentSnapshot snapshot) {
    final json = snapshot.data() as Map<String, dynamic>?;
    if (json == null) {
      return null;
    }

    json[State.idField] = snapshot.id;
    json[State.typeField] ??= stateType;

    return statePersister.inflate(json);
  }
}
