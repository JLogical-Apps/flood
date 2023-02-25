import 'package:example/features/user/user_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Budget extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).required();

  static const ownerField = 'owner';
  late final ownerProperty = reference<UserEntity>(name: ownerField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty, ownerProperty];
}
