import 'package:example/features/user/user_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class Budget extends ValueObject {
  late final nameProperty = field<String>(name: 'name').required();

  static const ownerField = 'owner';
  late final ownerProperty = reference<UserEntity>(name: ownerField);

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty, ownerProperty];
}
