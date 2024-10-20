import 'dart:async';

import 'package:actions_core/actions_core.dart';
import 'package:auth_core/auth_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('security rules for authenticated users.', () async {
    final documentRepository =
        DocumentRepository().withSecurity(RepositorySecurity.public().withWrite(Permission.authenticated));
    final loggedInAccountX = BehaviorSubject<Account?>.seeded(null);

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(
      loggedInAccountGetter: () => loggedInAccountX.value,
    ));
    await corePondContext.register(documentRepository);

    // Test create
    final documentEntity = await expectFailsWithoutAuth(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      loggedInAccountX,
    );

    // Test update
    await expectFailsWithoutAuth(
      () => documentRepository.updateEntity(documentEntity, (document) => Document()),
      loggedInAccountX,
    );

    // Test delete
    await expectFailsWithoutAuth(
      () => documentRepository.delete(documentEntity),
      loggedInAccountX,
    );

    // Test read
    await expectPassesWithoutAuth(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      loggedInAccountX,
    );
  });

  test('security rules for all users.', () async {
    final documentRepository = DocumentRepository().withSecurity(RepositorySecurity.public());
    final loggedInAccountX = BehaviorSubject<Account?>.seeded(null);

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent(loggedInAccountGetter: () => loggedInAccountX.value));
    await corePondContext.register(documentRepository);

    // Test create
    final documentEntity = await expectPassesWithoutAuth(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      loggedInAccountX,
    );

    // Test update
    await expectPassesWithoutAuth(
      () => documentRepository.updateEntity(documentEntity, (document) => Document()),
      loggedInAccountX,
    );

    // Test delete
    await expectPassesWithoutAuth(
      () => documentRepository.delete(documentEntity),
      loggedInAccountX,
    );

    // Test read
    await expectPassesWithoutAuth(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      loggedInAccountX,
    );
  });

  test('security rules for blocked users.', () async {
    final documentRepository = DocumentRepository().withSecurity(RepositorySecurity.readWrite(
      read: Permission.none,
      write: Permission.none,
    ));
    final loggedInAccountX = BehaviorSubject<Account?>.seeded(Account(accountId: 'user1'));

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent(loggedInAccountGetter: () => loggedInAccountX.value));
    await corePondContext.register(documentRepository);

    // Test create
    expect(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      throwsException,
    );

    // Test read
    expect(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      throwsException,
    );
  });

  test('security rules for admin users.', () async {
    final documentRepository = DocumentRepository().withSecurity(RepositorySecurity.readWrite(
      read: Permission.all,
      write: Permission.admin,
    ));
    final loggedInAccountX = BehaviorSubject<Account?>.seeded(Account(accountId: 'user1'));

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(loggedInAccountGetter: () => loggedInAccountX.value));
    await corePondContext.register(documentRepository);
    await corePondContext.register(UserRepository());

    await corePondContext.dropCoreComponent.updateEntity(UserEntity()
      ..id = 'admin'
      ..set(User()));

    // Test create
    await expectLater(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      throwsException,
    );

    // Test read
    await expectLater(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      returnsNormally,
    );

    loggedInAccountX.value = Account(accountId: 'admin', isAdmin: true);

    // Test create
    await expectLater(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      returnsNormally,
    );

    // Test read
    await expectLater(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      returnsNormally,
    );
  });

  test('security rules for specific users.', () async {
    const userId = 'user1';
    final userRepository = UserRepository().withSecurity(RepositorySecurity.readWrite(
      read: Permission.equals(PermissionField.entityId, PermissionField.loggedInUserId),
      write: Permission.equals(PermissionField.entityId, PermissionField.loggedInUserId),
    ));
    final loggedInAccountX = BehaviorSubject<Account?>.seeded(Account(accountId: userId));

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(loggedInAccountGetter: () => loggedInAccountX.value));
    await corePondContext.register(userRepository);

    // Test create
    await expectLater(
      userRepository.updateEntity(UserEntity()
        ..id = userId
        ..set(User())),
      completes,
    );

    // Test read. Expect to see the one UserEntity.
    final userEntities = await userRepository.executeQuery(Query.from<UserEntity>().all());
    expect(
      userEntities.isNotEmpty,
      isTrue,
    );

    loggedInAccountX.value = Account(accountId: 'someOtherUserId');

    // Test create
    await expectLater(
      () => userRepository.updateEntity(UserEntity()
        ..id = 'randomId'
        ..set(User())),
      throwsException,
    );

    // Throw when attempting to access the invalid user.
    await expectLater(
      () => userRepository.executeQuery(Query.from<UserEntity>().all()),
      throwsException,
    );
  });

  test('security rules for extracted currently logged-in user.', () async {
    const userId = 'user1';
    const otherUserId = 'user2';

    final userRepository = UserRepository();
    final documentRepository = DocumentRepository().withSecurity(RepositorySecurity.all(Permission.equals(
            PermissionField.entityId,
            PermissionField.entity<UserEntity>(PermissionField.loggedInUserId).propertyName(User.documentField)) |
        Permission.equals(PermissionField.propertyName(Document.ownerField), PermissionField.loggedInUserId)));
    final loggedInAccountX = BehaviorSubject<Account?>.seeded(Account(accountId: userId));

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(loggedInAccountGetter: () => loggedInAccountX.value));
    await corePondContext.register(userRepository);
    await corePondContext.register(documentRepository);

    await userRepository.updateEntity(UserEntity()
      ..id = userId
      ..set(User()));

    await expectLater(
      () =>
          corePondContext.dropCoreComponent.updateEntity(DocumentEntity()..set(Document()..ownerProperty.set(userId))),
      returnsNormally,
    );
    await expectLater(
      () => corePondContext.dropCoreComponent.updateEntity(DocumentEntity()..set(Document()..ownerProperty.set('123'))),
      throwsException,
    );
    await expectLater(
      () => corePondContext.dropCoreComponent.updateEntity(DocumentEntity()..set(Document())),
      throwsException,
    );

    final queriedDocument = await Query.from<DocumentEntity>().first().get(corePondContext.dropCoreComponent);
    expect(queriedDocument, isNotNull);

    loggedInAccountX.value = Account(accountId: otherUserId);

    await userRepository.updateEntity(UserEntity()
      ..id = otherUserId
      ..set(User()..documentProperty.set(queriedDocument.id!)));

    await expectLater(
        () => Query.from<DocumentEntity>().first().get(corePondContext.dropCoreComponent), returnsNormally);

    final otherQueriedDocument =
        await Query.getById<DocumentEntity>(queriedDocument.id!).get(corePondContext.dropCoreComponent);

    await expectLater(
      await corePondContext.dropCoreComponent
          .updateEntity(otherQueriedDocument, (Document document) => document..ownerProperty.set(null)),
      isNotNull,
    );

    await userRepository.updateEntity(UserEntity()
      ..id = otherUserId
      ..set(User()..documentProperty.set(null)));

    await expectLater(
      () => Query.getByIdOrNull<DocumentEntity>(queriedDocument.id!).get(corePondContext.dropCoreComponent),
      throwsException,
    );
  });
}

Future<T> expectFailsWithoutAuth<T>(
  FutureOr<T> Function() function,
  BehaviorSubject<Account?> loggedInAccountX,
) async {
  loggedInAccountX.value = null;

  final completer = Completer();
  expect(
    () async {
      try {
        await function();
      } finally {
        completer.complete();
      }
    },
    throwsException,
  );

  await completer.future;

  loggedInAccountX.value = Account(accountId: 'user1');
  return await function();
}

Future<T> expectPassesWithoutAuth<T>(
  FutureOr<T> Function() function,
  BehaviorSubject<Account?> loggedInAccountX,
) async {
  loggedInAccountX.value = null;

  final completer = Completer();
  expect(
    () async {
      try {
        await function();
      } finally {
        completer.complete();
      }
    },
    returnsNormally,
  );

  await completer.future;

  loggedInAccountX.value = Account(accountId: 'user1');

  return await function();
}

class Document extends ValueObject {
  static const ownerField = 'owner';
  late final ownerProperty = reference<UserEntity>(name: ownerField);

  @override
  List<ValueObjectBehavior> get behaviors => [ownerProperty];
}

class DocumentEntity extends Entity<Document> {}

class DocumentRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<DocumentEntity, Document>(
    DocumentEntity.new,
    Document.new,
    entityTypeName: 'DocumentEntity',
    valueObjectTypeName: 'Document',
  ).memory();
}

class User extends ValueObject {
  static const documentField = 'document';
  late final documentProperty = reference<DocumentEntity>(name: documentField);

  @override
  List<ValueObjectBehavior> get behaviors => [documentProperty];
}

class UserEntity extends Entity<User> {}

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  ).memory();
}
