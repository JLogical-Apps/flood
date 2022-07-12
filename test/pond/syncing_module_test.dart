import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  test('publishing uploads entities.', () async {
    var cacheStatesSaved = 0;
    var sourceStatesSaved = 0;

    AppContext.global = AppContext.createForTesting()
      ..register(SyncingModule())
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
      ..register(SyncingManualUserRepository(
        localRepository: localRepository,
        sourceRepository: sourceRepository,
      ))
      ..register(SyncingModule()..registerQueryDownload(() => Query.from<UserEntity>().all()));

    final userCountQuery = Query.from<UserEntity>().all().map((users) => users.length);

    expect(await localRepository.executeQuery(userCountQuery), 0);
    expect(await sourceRepository.executeQuery(userCountQuery), 2);

    await locate<SyncingModule>().download();
    await Future.delayed(Duration(milliseconds: 100));

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

class SyncingManualUserRepository extends SyncingRepository<UserEntity, User> {
  @override
  final EntityRepository localRepository;

  @override
  final EntityRepository sourceRepository;

  SyncingManualUserRepository({required this.localRepository, required this.sourceRepository});
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
