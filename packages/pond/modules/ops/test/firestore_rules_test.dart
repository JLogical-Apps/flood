import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/firebase_security_rules_generator.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('generate firestore.rules', () async {
    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent());
    await corePondContext.register(UserRepository());
    await corePondContext.register(DocumentRepository());

    final firestoreRules = FirebaseSecurityRulesGenerator().generateFirestoreRules(corePondContext);
    expect(firestoreRules, '''\
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }
    match /users/{id} {
      allow read: if (request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
      allow create: if (request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
      allow update: if (request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
      allow delete: if (request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
    }
    match /documents/{id} {
      allow read: if (request.auth.uid != null && request.auth.token.admin == true) || (resource.data.owner == request.auth.uid);
      allow create: if (request.auth.uid != null && request.auth.token.admin == true) || (request.resource.data.owner == request.auth.uid);
      allow update: if (request.auth.uid != null && request.auth.token.admin == true) || (request.resource.data.owner == request.auth.uid && resource.data.owner == request.auth.uid);
      allow delete: if false;
    }
  }
}''');
  });
}

class User extends ValueObject {}

class UserEntity extends Entity<User> {}

class UserRepository with IsRepositoryWrapper {
  @override
  late final Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  ).cloud('users').withSecurity(RepositorySecurity.all(Permission.admin |
      Permission.equals(
        PermissionField.entityId,
        PermissionField.loggedInUserId,
      )));
}

class Document extends ValueObject {
  static const ownerField = 'owner';
  late final ownerProperty = field<String>(name: ownerField);

  @override
  List<ValueObjectBehavior> get behaviors => [ownerProperty];
}

class DocumentEntity extends Entity<Document> {}

class DocumentRepository with IsRepositoryWrapper {
  @override
  late final Repository repository = Repository.forType<DocumentEntity, Document>(
    DocumentEntity.new,
    Document.new,
    entityTypeName: 'DocumentEntity',
    valueObjectTypeName: 'Document',
  ).cloud('documents').withSecurity(RepositorySecurity.all(Permission.admin |
          Permission.equals(
            PermissionField.propertyName(Document.ownerField),
            PermissionField.loggedInUserId,
          ))
      .copyWith(delete: Permission.none));
}
