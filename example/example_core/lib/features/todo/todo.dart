import 'package:example_core/features/user/user_entity.dart';
import 'package:flood_core/flood_core.dart';

class Todo extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const descriptionField = 'description';
  late final descriptionProperty =
      field<String>(name: descriptionField).withDisplayName('Description').multiline().nullIfBlank();

  static const completedField = 'completed';
  late final completedProperty = field<bool>(name: completedField).hidden().withFallback(() => false);

  static const userField = 'user';
  late final userProperty = reference<UserEntity>(name: userField).hidden().required();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    descriptionProperty,
    completedProperty,
    userProperty,
    creationTime(),
  ];
}
