import 'dart:typed_data';

import 'package:actions_core/actions_core.dart';
import 'package:asset_core/asset_core.dart';
import 'package:auth_core/auth_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  const userId = 'userId';

  late CorePondContext corePondContext;
  late BehaviorSubject<Account?> loggedInAccountX;

  setUp(() async {
    loggedInAccountX = BehaviorSubject<Account?>.seeded(Account(accountId: userId, isAdmin: true));

    corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(loggedInAccountGetter: () => loggedInAccountX.value));
    await corePondContext.register(UserRepository());
    await corePondContext.register(TodoRepository());
  });

  test('uploading and deleting', () async {
    await corePondContext.register(AssetCoreComponent(
      loggedInAccountGetter: () => loggedInAccountX.value,
      assetProviders: (context) => [
        UserProfilePictureAssetProvider(context),
        TodoAssetProvider(context),
      ],
    ));

    final userEntity = await corePondContext.dropCoreComponent.updateEntity(UserEntity()
      ..id = userId
      ..set(User()));
    final todoEntity =
        await corePondContext.dropCoreComponent.updateEntity(TodoEntity()..set(Todo()..userProperty.set(userId)));

    var uploadedAsset = await userEntity.value.profilePictureProperty.uploadAsset(
      corePondContext.assetCoreComponent,
      Asset.upload(
        path: 'image.png',
        value: Uint8List.fromList([]),
      ),
    );

    expect(userEntity.value.profilePictureProperty.value!.assetId, uploadedAsset.id);

    final oldUploadedAsset = uploadedAsset;

    uploadedAsset = await userEntity.value.profilePictureProperty.uploadAsset(
      corePondContext.assetCoreComponent,
      Asset.upload(
        path: 'image.png',
        value: Uint8List.fromList([]),
      ),
    );

    expect(oldUploadedAsset.id, isNot(uploadedAsset.id));

    uploadedAsset = await todoEntity.value.assetsProperty.uploadAsset(
      corePondContext.assetCoreComponent,
      Asset.upload(
        path: 'image.png',
        value: Uint8List.fromList([]),
      ),
    );

    expect(todoEntity.value.assetsProperty.value[0].assetId, uploadedAsset.id);

    await todoEntity.value.assetsProperty.deleteAsset(corePondContext.assetCoreComponent, uploadedAsset.id);

    expect(todoEntity.value.assetsProperty.value, isEmpty);
  });

  test('asset security', () async {
    await corePondContext.register(AssetCoreComponent(
      loggedInAccountGetter: () => loggedInAccountX.value,
      assetProviders: (context) => [
        UserProfilePictureAssetProvider(
          context,
          assetSecurity: AssetSecurity(
            read: AssetPermission.authenticated,
            create: AssetPermission.equals(AssetPermissionField.loggedInUserId, AssetPermissionField.entityId),
            update: AssetPermission.equals(AssetPermissionField.loggedInUserId, AssetPermissionField.entityId),
            delete: AssetPermission.admin &
                AssetPermission.equals(AssetPermissionField.loggedInUserId, AssetPermissionField.entityId),
          ),
        ),
        TodoAssetProvider(
          context,
          assetSecurity: AssetSecurity(
            read: AssetPermission.authenticated,
            create: AssetPermission.equals(
              AssetPermissionField.loggedInUserId,
              AssetPermissionField.entity<TodoEntity>(AssetPermissionField.entityId).propertyName(Todo.userField),
            ),
            update: AssetPermission.equals(
              AssetPermissionField.loggedInUserId,
              AssetPermissionField.entity<TodoEntity>(AssetPermissionField.entityId).propertyName(Todo.userField),
            ),
            delete: AssetPermission.admin &
                AssetPermission.equals(
                  AssetPermissionField.loggedInUserId,
                  AssetPermissionField.entity<TodoEntity>(AssetPermissionField.entityId).propertyName(Todo.userField),
                ),
          ),
        ),
      ],
    ));

    final userEntity = await corePondContext.dropCoreComponent.updateEntity(UserEntity()
      ..id = userId
      ..set(User()));
    final todoEntity =
        await corePondContext.dropCoreComponent.updateEntity(TodoEntity()..set(Todo()..userProperty.set(userId)));
    final otherTodoEntity = await corePondContext.dropCoreComponent.runWithoutSecurity(() =>
        corePondContext.dropCoreComponent.updateEntity(TodoEntity()..set(Todo()..userProperty.set('someOtherId'))));

    await userEntity.value.profilePictureProperty.uploadAsset(
      corePondContext.assetCoreComponent,
      Asset.upload(
        path: 'image.png',
        value: Uint8List.fromList([]),
      ),
    );

    await todoEntity.value.assetsProperty.uploadAsset(
      corePondContext.assetCoreComponent,
      Asset.upload(
        path: 'image.png',
        value: Uint8List.fromList([]),
      ),
    );

    expect(
      () => otherTodoEntity.value.assetsProperty.uploadAsset(
        corePondContext.assetCoreComponent,
        Asset.upload(path: 'image.png', value: Uint8List.fromList([])),
      ),
      throwsException,
    );

    loggedInAccountX.value = Account(accountId: userId, isAdmin: false);

    expect(
      () => userEntity.value.profilePictureProperty.deleteAsset(corePondContext.assetCoreComponent),
      throwsException,
    );

    expect(
      () => todoEntity.value.assetsProperty.deleteAsset(corePondContext.assetCoreComponent, userId),
      throwsException,
    );

    loggedInAccountX.value = Account(accountId: 'someOtherUserId', isAdmin: true);

    expect(
      () => userEntity.value.profilePictureProperty.uploadAsset(
        corePondContext.assetCoreComponent,
        Asset.upload(
          path: 'image.png',
          value: Uint8List.fromList([]),
        ),
      ),
      throwsException,
    );

    expect(
      () => todoEntity.value.assetsProperty.uploadAsset(
        corePondContext.assetCoreComponent,
        Asset.upload(
          path: 'image.png',
          value: Uint8List.fromList([]),
        ),
      ),
      throwsException,
    );
  });

  test('asset security from repository', () async {
    await corePondContext.register(AssetCoreComponent(
      loggedInAccountGetter: () => loggedInAccountX.value,
      assetProviders: (context) => [
        UserProfilePictureAssetProvider(
          context,
          assetSecurity: AssetSecurity.fromRepository(context.context.locate<UserRepository>()),
        ),
        TodoAssetProvider(
          context,
          assetSecurity: AssetSecurity.fromRepository(context.context.locate<TodoRepository>()),
        ),
      ],
    ));

    final userEntity = await corePondContext.dropCoreComponent.updateEntity(UserEntity()
      ..id = userId
      ..set(User()));
    final todoEntity =
        await corePondContext.dropCoreComponent.updateEntity(TodoEntity()..set(Todo()..userProperty.set(userId)));
    final otherTodoEntity = await corePondContext.dropCoreComponent.runWithoutSecurity(() =>
        corePondContext.dropCoreComponent.updateEntity(TodoEntity()..set(Todo()..userProperty.set('someOtherId'))));

    await userEntity.value.profilePictureProperty.uploadAsset(
      corePondContext.assetCoreComponent,
      Asset.upload(
        path: 'image.png',
        value: Uint8List.fromList([]),
      ),
    );

    await todoEntity.value.assetsProperty.uploadAsset(
      corePondContext.assetCoreComponent,
      Asset.upload(
        path: 'image.png',
        value: Uint8List.fromList([]),
      ),
    );

    expect(
      () => otherTodoEntity.value.assetsProperty.uploadAsset(
        corePondContext.assetCoreComponent,
        Asset.upload(path: 'image.png', value: Uint8List.fromList([])),
      ),
      throwsException,
    );

    loggedInAccountX.value = Account(accountId: userId, isAdmin: false);

    expect(
      () => userEntity.value.profilePictureProperty.deleteAsset(corePondContext.assetCoreComponent),
      throwsException,
    );

    expect(
      () => todoEntity.value.assetsProperty.deleteAsset(corePondContext.assetCoreComponent, userId),
      throwsException,
    );

    loggedInAccountX.value = Account(accountId: 'someOtherUserId', isAdmin: true);

    expect(
      () => userEntity.value.profilePictureProperty.uploadAsset(
        corePondContext.assetCoreComponent,
        Asset.upload(
          path: 'image.png',
          value: Uint8List.fromList([]),
        ),
      ),
      throwsException,
    );

    expect(
      () => todoEntity.value.assetsProperty.uploadAsset(
        corePondContext.assetCoreComponent,
        Asset.upload(
          path: 'image.png',
          value: Uint8List.fromList([]),
        ),
      ),
      throwsException,
    );
  });
}

class User extends ValueObject {
  static const profilePictureField = 'profilePicture';
  late final profilePictureProperty = field<String>(name: profilePictureField).asset(
    assetProvider: (context) => context.locate<UserProfilePictureAssetProvider>(),
  );

  @override
  List<ValueObjectBehavior> get behaviors => [profilePictureProperty];
}

class UserEntity extends Entity<User> {}

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  ).memory().withSecurity(RepositorySecurity.readWrite(
          read: Permission.authenticated,
          write: Permission.equals(PermissionField.loggedInUserId, PermissionField.entityId))
      .withDelete(Permission.admin & Permission.equals(PermissionField.loggedInUserId, PermissionField.entityId)));
}

class UserProfilePictureAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  final AssetSecurity? assetSecurity;

  UserProfilePictureAssetProvider(this.context, {this.assetSecurity});

  @override
  late final AssetProvider assetProvider =
      AssetProvider.static.memory.withSecurity(assetSecurity ?? AssetSecurity.all(AssetPermission.all));
}

class Todo extends ValueObject {
  static const userField = 'user';
  late final userProperty = reference<UserEntity>(name: userField).hidden().required();

  static const assetsField = 'assets';
  late final assetsProperty = field<String>(name: assetsField)
      .asset(assetProvider: (context) => context.locate<TodoAssetProvider>())
      .list()
      .withDisplayName('Assets');

  @override
  late final List<ValueObjectBehavior> behaviors = [
    userProperty,
    assetsProperty,
    creationTime(),
  ];
}

class TodoEntity extends Entity<Todo> {}

class TodoRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<TodoEntity, Todo>(
    TodoEntity.new,
    Todo.new,
    entityTypeName: 'TodoEntity',
    valueObjectTypeName: 'Todo',
  ).memory().withSecurity(RepositorySecurity.readWrite(
          read: Permission.authenticated,
          write: Permission.equals(PermissionField.loggedInUserId, PermissionField.propertyName(Todo.userField)))
      .withDelete(Permission.admin &
          Permission.equals(
            PermissionField.loggedInUserId,
            PermissionField.propertyName(Todo.userField),
          )));
}

class TodoAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;
  final AssetSecurity? assetSecurity;

  TodoAssetProvider(this.context, {this.assetSecurity});

  @override
  late final AssetProvider assetProvider =
      AssetProvider.static.memory.withSecurity(assetSecurity ?? AssetSecurity.all(AssetPermission.all));
}
