import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_cloud_repository.dart';
import 'package:firebase/src/drop/firebase_timestamp_state_persister_modifier.dart';
import 'package:type/type.dart';

class FirebaseCloudRepositoryStateHandler with IsRepositoryStateHandler {
  final FirebaseCloudRepository repository;

  FirebaseCloudRepositoryStateHandler({required this.repository});

  CollectionReference get collection => FirebaseFirestore.instance.collection(repository.rootPath);

  RuntimeType? get inferredType => repository.handledTypes.length == 1 ? repository.handledTypes[0] : null;

  late StatePersister<Map<String, dynamic>> statePersister = StatePersister.json(
    context: repository.context.dropCoreComponent,
    extraStatePersisterModifiers: [
      FirebaseTimestampStatePersisterModifier(),
    ],
  );

  @override
  Future<State> onUpdate(State state) async {
    final doc = collection.doc(state.id!);
    final json = statePersister.persist(state);

    json.remove(State.idField);

    if (state.type == inferredType) {
      json.remove(State.typeField);
    }

    await doc.set(json);

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    final id = state.id ?? (throw Exception('Cannot delete entity that has not been saved yet!'));
    final doc = collection.doc(id);
    await doc.delete();

    return state;
  }
}
