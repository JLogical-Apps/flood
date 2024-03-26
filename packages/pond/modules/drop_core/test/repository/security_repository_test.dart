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
      throwsA(isA<Exception>()),
    );

    // Test read
    expect(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      throwsA(isA<Exception>()),
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
    expect(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      throwsA(isA<Exception>()),
    );

    // Test read
    expect(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      returnsNormally,
    );

    // Allow previous [expect] to run before changing to admin user.
    await Future(() {});
    loggedInAccountX.value = Account(accountId: 'admin', isAdmin: true);

    // Test create
    expect(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      returnsNormally,
    );

    // Test read
    expect(
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
    expect(
      () => userRepository.updateEntity(UserEntity()
        ..id = userId
        ..set(User())),
      returnsNormally,
    );

    // Allow previous [expect] to run before changing to admin user.
    await Future(() {});

    // Test read. Expect to see the one UserEntity.
    var userEntities = await userRepository.executeQuery(Query.from<UserEntity>().all());
    expect(
      userEntities.isNotEmpty,
      isTrue,
    );

    // Allow previous [expect] to run before changing to admin user.
    await Future(() {});
    loggedInAccountX.value = Account(accountId: 'someOtherUserId');

    // Test create
    expect(
      () => userRepository.updateEntity(UserEntity()
        ..id = 'randomId'
        ..set(User())),
      throwsA(isA<Exception>()),
    );

    // Instead of throwing, permissions should just hide entities they do not have access to.
    userEntities = await userRepository.executeQuery(Query.from<UserEntity>().all());
    expect(
      userEntities.isEmpty,
      isTrue,
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
    throwsA(isA<Exception>()),
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

class Document extends ValueObject {}

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

class User extends ValueObject {}

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
