import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/src/drop/appwrite_cloud_repository.dart';
import 'package:appwrite_app/src/drop/appwrite_map_state_persister_modifier.dart';
import 'package:appwrite_app/src/drop/appwrite_timestamp_state_persister_modifier.dart';
import 'package:appwrite_app/src/drop/appwrite_value_object_state_persister_modifier.dart';
import 'package:appwrite_app/src/util/appwrite_core_component_extensions.dart';
import 'package:appwrite_core/appwrite_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:log_core/log_core.dart';
import 'package:type/type.dart';
import 'package:utils/utils.dart';

class AppwriteCloudRepositoryStateHandler with IsRepositoryStateHandler {
  final AppwriteCloudRepository repository;

  AppwriteCloudRepositoryStateHandler({required this.repository});

  late final Databases databases = Databases(repository.context.client);

  RuntimeType? get inferredType => repository.handledTypes.length == 1 ? repository.handledTypes[0] : null;

  @override
  late StatePersister<Map<String, dynamic>> statePersister = getStatePersister(repository.context.dropCoreComponent);

  static StatePersister<Map<String, dynamic>> getStatePersister(DropCoreContext context) => StatePersister.json(
        context: context,
        extraStatePersisterModifiers: [
          AppwriteValueObjectStatePersisterModifier(
            context,
            statePersisterGetter: () => getStatePersister(context),
          ),
          AppwriteMapStatePersisterModifier(
            statePersisterGetter: () => getStatePersister(context),
          ),
          AppwriteTimestampStatePersisterModifier(),
        ],
      );

  @override
  Future<State> onUpdate(State state) async {
    repository.context.log('Saving state to Appwrite: [$state]');

    final json = statePersister.persist(state);

    json.remove(State.idField);

    if (state.type == inferredType) {
      json.remove(State.typeField);
    } else {
      json[AppwriteConsts.typeKey] = json.remove(State.typeField);
    }

    final existingDocument = await guardAsync(() => databases.getDocument(
          databaseId: AppwriteCloudRepository.defaultDatabaseId,
          collectionId: repository.rootPath,
          documentId: state.id!,
        ));
    if (existingDocument == null) {
      await databases.createDocument(
        documentId: state.id!,
        collectionId: repository.rootPath,
        databaseId: AppwriteCloudRepository.defaultDatabaseId,
        data: json,
      );
    } else {
      await databases.updateDocument(
        documentId: state.id!,
        collectionId: repository.rootPath,
        databaseId: AppwriteCloudRepository.defaultDatabaseId,
        data: json,
      );
    }

    await databases.updateDocument(
      documentId: state.id!,
      collectionId: repository.rootPath,
      databaseId: AppwriteCloudRepository.defaultDatabaseId,
      data: json,
    );

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    repository.context.log('Deleting state to Appwrite: [$state]');

    await databases.deleteDocument(
      documentId: state.id ?? (throw Exception('Cannot delete entity that has not been saved yet!')),
      collectionId: repository.rootPath,
      databaseId: AppwriteCloudRepository.defaultDatabaseId,
    );

    return state;
  }
}
