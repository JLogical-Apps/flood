import 'package:flood_core/flood_core.dart';

class User extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank().isName();

  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).withDisplayName('Email').hidden().isEmail().isNotBlank();

  static const deviceTokenField = 'deviceToken';
  late final deviceTokenProperty = field<String>(name: deviceTokenField).hidden();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    emailProperty,
    deviceTokenProperty,
    creationTime(),
  ];
}
