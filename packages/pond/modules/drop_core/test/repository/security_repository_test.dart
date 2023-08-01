import 'dart:async';

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
  late Repository repository = Repository.memory().forType<DocumentEntity, Document>(
    DocumentEntity.new,
    Document.new,
    entityTypeName: 'DocumentEntity',
    valueObjectTypeName: 'Document',
  );
}
