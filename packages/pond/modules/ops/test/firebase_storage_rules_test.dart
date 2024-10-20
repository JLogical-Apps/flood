import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:environment_core/environment_core.dart';
import 'package:ops/src/firebase/firebase_security_rules_generator.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('generate storage.rules', () async {
    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent());
    await corePondContext.register(EnvironmentConfigCoreComponent(
        environmentConfig: EnvironmentConfig.static.testing().withEnvironmentType(EnvironmentType.static.production)));
    await corePondContext.register(AssetCoreComponent(
        assetProviders: (context) => [
              UserAssetProvider(context: context),
              DocumentAssetProvider(context: context),
              AttachmentAssetProvider(context: context),
            ]));

    await corePondContext.register(UserRepository());
    await corePondContext.register(DocumentRepository());
    await corePondContext.register(AttachmentRepository());

    final firebaseStorageRules = FirebaseSecurityRulesGenerator().generateFirebaseStorageRules(corePondContext);
    expect(firebaseStorageRules, '''\
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{assetIds=**} {
      allow read, write: if false;
    }
    match /users/{id}/profilePicture/{assetIds=**} {
      allow read: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
      allow create: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
      allow update: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
      allow delete: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (id == request.auth.uid);
    }
    match /documents/{id}/assets/{assetIds=**} {
      allow read: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (firestore.get(/databases/(default)/documents/documents/\$(id)).data.owner == request.auth.uid);
      allow create: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (firestore.exists(/databases/(default)/documents/documents/\$(id)) ? (firestore.get(/databases/(default)/documents/documents/\$(id)).data.owner == request.auth.uid) : (request.auth != null));
      allow update: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (firestore.get(/databases/(default)/documents/documents/\$(id)).data.owner == request.auth.uid);
      allow delete: if (request.auth != null && request.auth.uid != null && request.auth.token.admin == true) || (firestore.get(/databases/(default)/documents/documents/\$(id)).data.owner == request.auth.uid);
    }
    match /attachments/{id}/assets/{assetIds=**} {
      allow read: if (firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document == null) || (firestore.get(/databases/(default)/documents/documents/\$(firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document)).data.owner == request.auth.uid);
      allow create: if (firestore.exists(/databases/(default)/documents/attachments/\$(id)) ? (firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document == null) : (request.auth != null)) || (firestore.exists(/databases/(default)/documents/attachments/\$(id)) ? (firestore.get(/databases/(default)/documents/documents/\$(firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document)).data.owner == request.auth.uid) : (request.auth != null));
      allow update: if (firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document == null) || (firestore.get(/databases/(default)/documents/documents/\$(firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document)).data.owner == request.auth.uid);
      allow delete: if (firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document == null) || (firestore.get(/databases/(default)/documents/documents/\$(firestore.get(/databases/(default)/documents/attachments/\$(id)).data.document)).data.owner == request.auth.uid);
    }
  }
}''');
  });
}

class User extends ValueObject {
  static const profilePictureField = 'profilePicture';
  late final profilePictureProperty =
      field<String>(name: profilePictureField).asset(assetProvider: (context) => context.locate<UserAssetProvider>());

  @override
  List<ValueObjectBehavior> get behaviors => [profilePictureProperty];
}

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

class UserAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  UserAssetProvider({required this.context});

  @override
  late final AssetProvider assetProvider = AssetProvider.static
      .adapting(context, (context) => 'users/${context.entityId}/profilePicture')
      .fromRepository<UserEntity>(context);
}

class Document extends ValueObject {
  static const ownerField = 'owner';
  late final ownerProperty = field<String>(name: ownerField);

  static const assetsField = 'assets';
  late final assetsProperty = field<String>(name: assetsField)
      .asset(assetProvider: (context) => context.locate<DocumentAssetProvider>())
      .list();

  @override
  List<ValueObjectBehavior> get behaviors => [ownerProperty, assetsProperty];
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

class DocumentAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  DocumentAssetProvider({required this.context});

  @override
  late final AssetProvider assetProvider = AssetProvider.static
      .adapting(context, (context) => 'documents/${context.entityId}/assets')
      .fromRepository<DocumentEntity>(context);
}

class Attachment extends ValueObject {
  static const documentField = 'document';
  late final documentProperty = reference<DocumentEntity>(name: documentField).required();

  static const assetsField = 'assets';
  late final assetsProperty = field<String>(name: assetsField)
      .asset(assetProvider: (context) => context.locate<DocumentAssetProvider>())
      .list();

  @override
  List<ValueObjectBehavior> get behaviors => [documentProperty, assetsProperty];
}

class AttachmentEntity extends Entity<Attachment> {}

class AttachmentRepository with IsRepositoryWrapper {
  @override
  late final Repository repository = Repository.forType<AttachmentEntity, Attachment>(
    AttachmentEntity.new,
    Attachment.new,
    entityTypeName: 'AttachmentEntity',
    valueObjectTypeName: 'Attachment',
  ).cloud('attachments').withSecurity(RepositorySecurity.all(Permission.equals(
        PermissionField.propertyName(Attachment.documentField),
        PermissionField.value(null),
      ) |
      Permission.equals(
        PermissionField.entity<DocumentEntity>(PermissionField.propertyName(Attachment.documentField))
            .propertyName(Document.ownerField),
        PermissionField.loggedInUserId,
      )));
}

class AttachmentAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  AttachmentAssetProvider({required this.context});

  @override
  late final AssetProvider assetProvider = AssetProvider.static
      .adapting(context, (context) => 'attachments/${context.entityId}/assets')
      .fromRepository<AttachmentEntity>(context);
}
