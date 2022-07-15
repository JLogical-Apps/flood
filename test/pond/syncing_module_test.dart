import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/local_sync_publish_actions_repository.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/publish_actions/save_sync_publish_action.dart';
import 'package:jlogical_utils/src/pond/modules/syncing/publish_actions/save_sync_publish_action_entity.dart';

void main() {
  test('publishing uploads entities.', () async {
    var cacheStatesSaved = 0;
    var sourceStatesSaved = 0;

    AppContext.global = AppContext.createForTesting()
      ..register(SyncingModule.testing())
      ..register(SyncingUserRepository(
        onCacheStateSaved: (s) => cacheStatesSaved++,
        onSourceStateSaved: (s) => sourceStatesSaved++,
      ));

    final userEntities = [
      UserEntity()..value = (User()..emailProperty.value = 'a@a.com'),
      UserEntity()..value = (User()..emailProperty.value = 'b@b.com'),
    ];
    await Future.wait(userEntities.map((user) => user.create()));

    expect(cacheStatesSaved, 2);
    expect(sourceStatesSaved, 0);

    await locate<SyncingModule>().publish();

    expect(cacheStatesSaved, 2);
    expect(sourceStatesSaved, 2);
  });

  test('loading pending publishes and publishing uploads entities and clears queue.', () async {
    AppContext.global = AppContext.createForTesting();

    final pendingUserEntities = [
      UserEntity()
        ..id = 'a'
        ..value = (User()..emailProperty.value = 'a@a.com'),
      UserEntity()
        ..id = 'b'
        ..value = (User()..emailProperty.value = 'b@b.com'),
    ];
    final pendingSaveEntities = pendingUserEntities.map((entity) => SaveSyncPublishActionEntity()
      ..id = entity.id
      ..value = (SaveSyncPublishAction.fromSaveState(entity.state)));
    final pendingSaveStates = pendingSaveEntities.map((entity) => entity.state).toList();

    final localSyncPublishActionsRepository = LocalSyncPublishActionsRepository();
    for (final state in pendingSaveStates) {
      await localSyncPublishActionsRepository.saveState(state);
    }

    final syncingUserRepository =
        LocalUserRepository().asSyncingRepository<UserEntity, User>(localRepository: LocalUserRepository());

    AppContext.global = AppContext.createForTesting()
      ..register(SyncingModule(syncPublishActionsRepository: localSyncPublishActionsRepository))
      ..register(syncingUserRepository);
    await AppContext.global.load();

    final newUserEntity = UserEntity()..value = (User()..emailProperty.value = 'c@c.com');
    await newUserEntity.create();

    await locate<SyncingModule>().publish();

    final userEntities = await syncingUserRepository.sourceRepository.executeQuery(Query.from<UserEntity>().all());

    expect(userEntities, unorderedEquals([newUserEntity, ...pendingUserEntities]));
  });

  test('download downloads entities.', () async {
    // Initialize AppContext so serialization works.
    AppContext.global = AppContext.createForTesting();

    final initialUserEntities = [
      UserEntity()
        ..id = 'a'
        ..value = (User()..emailProperty.value = 'a@a.com'),
      UserEntity()
        ..id = 'b'
        ..value = (User()..emailProperty.value = 'b@b.com'),
    ];
    final initialUserStates = initialUserEntities.map((entity) => entity.state).toList();

    final localRepository = LocalUserRepository();
    final sourceRepository = LocalUserRepository(initialStates: initialUserStates);

    // Reinitialize AppContext with SyncingModule.
    AppContext.global = AppContext.createForTesting()
      ..register(sourceRepository.asSyncingRepository<UserEntity, User>(localRepository: localRepository))
      ..register(SyncingModule.testing()..registerQueryDownload(() => Query.from<UserEntity>().all()));

    final userCountQuery = Query.from<UserEntity>().all().map((users) => users.length);

    expect(await localRepository.executeQuery(userCountQuery), 0);
    expect(await sourceRepository.executeQuery(userCountQuery), 2);

    await locate<SyncingModule>().download();

    expect(await localRepository.executeQuery(userCountQuery), 2);
    expect(await sourceRepository.executeQuery(userCountQuery), 2);
  });
}

class SyncingUserRepository extends SyncingRepository<UserEntity, User> {
  final void Function(State state) onCacheStateSaved;
  final void Function(State state) onSourceStateSaved;

  SyncingUserRepository({required this.onCacheStateSaved, required this.onSourceStateSaved});

  @override
  late EntityRepository localRepository = LocalUserRepository(onStateSaved: onCacheStateSaved);

  @override
  late EntityRepository sourceRepository = LocalUserRepository(onStateSaved: onSourceStateSaved);
}

class LocalUserRepository extends DefaultLocalRepository<UserEntity, User> {
  void Function(State state)? onStateSaved;

  LocalUserRepository({this.onStateSaved, List<State>? initialStates}) {
    if (initialStates != null) {
      for (final state in initialStates) {
        saveState(state);
      }
    }
  }

  @override
  UserEntity createEntity() {
    return UserEntity();
  }

  @override
  User createValueObject() {
    return User();
  }

  @override
  Future<void> saveState(State state) {
    onStateSaved?.call(state);
    return super.saveState(state);
  }
}

class User extends ValueObject {
  late final emailProperty = FieldProperty<String>(name: 'email');

  @override
  List<Property> get properties => super.properties + [emailProperty];
}

class UserEntity extends Entity<User> {}
