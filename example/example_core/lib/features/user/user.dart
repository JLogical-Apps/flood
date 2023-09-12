import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class User extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).withDisplayName('Email').hidden().isEmail().isNotBlank();

  static const adminField = 'admin';
  late final adminProperty = field<bool>(name: adminField).hidden().withFallbackWithoutReplacement(() => false);

  static const deviceTokenField = 'deviceToken';
  late final deviceTokenProperty = field<String>(name: deviceTokenField).hidden();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    emailProperty,
    adminProperty,
    deviceTokenProperty,
    creationTime(),
  ];
}
