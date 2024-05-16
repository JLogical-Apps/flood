import 'package:flood_core/flood_core.dart';

class User extends ValueObject {
  static AssetProvider profilePictureAssetProvider = AssetProvider.static.memory;

  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank().isName();

  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).withDisplayName('Email').hidden().isEmail().isNotBlank();

  static const deviceTokenField = 'deviceToken';
  late final deviceTokenProperty = field<String>(name: deviceTokenField).hidden();

  static const profilePictureField = 'profilePicture';
  late final profilePictureProperty = field<String>(name: profilePictureField)
      .asset(assetProvider: profilePictureAssetProvider, allowedFileTypes: AllowedFileTypes.image)
      .withDisplayName('Profile Picture');

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    emailProperty,
    deviceTokenProperty,
    profilePictureProperty,
    creationTime(),
  ];
}
