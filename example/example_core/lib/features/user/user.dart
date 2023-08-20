import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class User extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).isNotBlank();

  static const adminField = 'admin';
  late final adminProperty = field<bool>(name: adminField).withFallbackWithoutReplacement(() => false);

  static const deviceTokenField = 'deviceToken';
  late final deviceTokenProperty = field<String>(name: deviceTokenField);

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    adminProperty,
    deviceTokenProperty,
    creationTime(),
  ];
}
