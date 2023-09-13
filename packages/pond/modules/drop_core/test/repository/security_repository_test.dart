import 'dart:async';

import 'package:actions_core/actions_core.dart';
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
    final authenticatedUserIdX = BehaviorSubject<String?>.seeded(null);

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(
      authenticatedUserIdX: authenticatedUserIdX,
    ));
    await corePondContext.register(documentRepository);

    // Test create
    final documentEntity = await expectFailsWithoutAuth(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      authenticatedUserIdX,
    );

    // Test update
    await expectFailsWithoutAuth(
      () => documentRepository.updateEntity(documentEntity, (document) => Document()),
      authenticatedUserIdX,
    );

    // Test delete
    await expectFailsWithoutAuth(
      () => documentRepository.delete(documentEntity),
      authenticatedUserIdX,
    );

    // Test read
    await expectPassesWithoutAuth(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      authenticatedUserIdX,
    );
  });

  test('security rules for all users.', () async {
    final documentRepository = DocumentRepository().withSecurity(RepositorySecurity.public());
    final authenticatedUserIdX = BehaviorSubject<String?>.seeded(null);

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent(
      authenticatedUserIdX: authenticatedUserIdX,
    ));
    await corePondContext.register(documentRepository);

    // Test create
    final documentEntity = await expectPassesWithoutAuth(
      () => documentRepository.updateEntity(DocumentEntity()..set(Document())),
      authenticatedUserIdX,
    );

    // Test update
    await expectPassesWithoutAuth(
      () => documentRepository.updateEntity(documentEntity, (document) => Document()),
      authenticatedUserIdX,
    );

    // Test delete
    await expectPassesWithoutAuth(
      () => documentRepository.delete(documentEntity),
      authenticatedUserIdX,
    );

    // Test read
    await expectPassesWithoutAuth(
      () => documentRepository.executeQuery(Query.fromAll().all()),
      authenticatedUserIdX,
    );
  });

  test('security rules for blocked users.', () async {
    final documentRepository = DocumentRepository().withSecurity(RepositorySecurity.readWrite(
      read: Permission.none,
      write: Permission.none,
    ));
    final authenticatedUserIdX = BehaviorSubject<String?>.seeded('user1');

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent(
      authenticatedUserIdX: authenticatedUserIdX,
    ));
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
      write: Permission.isAdmin(userEntityType: UserEntity, adminField: User.adminField),
    ));
    final authenticatedUserIdX = BehaviorSubject<String?>.seeded('user1');

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(
      authenticatedUserIdX: authenticatedUserIdX,
    ));
    await corePondContext.register(documentRepository);
    await corePondContext.register(UserRepository());

    await corePondContext.dropCoreComponent.updateEntity(UserEntity()
      ..id = 'admin'
      ..set(User()..adminProperty.set(true)));

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
    authenticatedUserIdX.value = 'admin';

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

  test('security rules for unmodifiable fields.', () async {
    final userRepository = UserRepository().withSecurity(RepositorySecurity(
      read: Permission.all,
      create: Permission.unmodifiable(User.adminField),
      update: Permission.unmodifiable(User.adminField),
      delete: Permission.isAdmin(userEntityType: UserEntity, adminField: User.adminField),
    ));

    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(ActionCoreComponent());
    await corePondContext.register(DropCoreComponent(
      authenticatedUserIdX: BehaviorSubject.seeded(null),
    ));
    await corePondContext.register(userRepository);

    final userEntity = await corePondContext.dropCoreComponent.updateEntity(UserEntity()
      ..id = 'admin'
      ..set(User()));

    expect(
      () => userRepository.updateEntity(userEntity, (User user) => user..adminProperty.set(true)),
      throwsA(isA<Exception>()),
    );

    expect(
      () => userRepository.updateEntity(UserEntity()..set(User()..adminProperty.set(false))),
      throwsA(isA<Exception>()),
    );
  });
}

Future<T> expectFailsWithoutAuth<T>(
  FutureOr<T> Function() function,
  BehaviorSubject<String?> authenticatedUserIdX,
) async {
  authenticatedUserIdX.value = null;

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

  authenticatedUserIdX.value = 'user1';
  return await function();
}

Future<T> expectPassesWithoutAuth<T>(
  FutureOr<T> Function() function,
  BehaviorSubject<String?> authenticatedUserIdX,
) async {
  authenticatedUserIdX.value = null;

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

  authenticatedUserIdX.value = 'user1';

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

class User extends ValueObject {
  static const adminField = 'admin';
  late final adminProperty = field<bool>(name: adminField).withFallbackWithoutReplacement(() => false);

  @override
  List<ValueObjectBehavior> get behaviors => [adminProperty];
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
