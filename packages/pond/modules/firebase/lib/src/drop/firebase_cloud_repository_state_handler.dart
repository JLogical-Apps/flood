import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_cloud_repository.dart';
import 'package:firebase/src/utils/firebase_context_extensions.dart';
import 'package:firebase/src/utils/firestore_document_state_persister.dart';
import 'package:log_core/log_core.dart';
import 'package:runtime_type/type.dart';
import 'package:utils/utils.dart';

class FirebaseCloudRepositoryStateHandler with IsRepositoryStateHandler {
  final FirebaseCloudRepository repository;

  FirebaseCloudRepositoryStateHandler({required this.repository});

  CollectionReference get collection =>
      repository.context.firebaseCoreComponent.firestore.collection(repository.rootPath);

  RuntimeType? get inferredType => repository.handledTypes.length == 1 ? repository.handledTypes[0] : null;

  late StatePersister<Map<String, dynamic>> statePersister =
      getDocumentSnapshotPersister(repository.context.dropCoreComponent);

  @override
  Future<State> onUpdate(State state) async {
    repository.context.log('Saving state to Firebase: [$state]');

    final doc = collection.doc(state.id!);
    final json = statePersister.persist(state);

    json.remove(State.idField);

    if (state.type == inferredType) {
      json.remove(State.typeField);
    }

    await doc.set(json, SetOptions(merge: true));

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    repository.context.log('Deleting state to Firebase: [$state]');

    final id = state.id ?? (throw Exception('Cannot delete entity that has not been saved yet!'));
    final doc = collection.doc(id);
    final snap = await guardAsync(() => doc.get());
    if (snap?.exists == true) {
      await doc.delete();
    }

    return state;
  }
}
