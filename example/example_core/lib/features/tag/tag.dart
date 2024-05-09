import 'package:example_core/features/user/user_entity.dart';
import 'package:flood_core/flood_core.dart';

class Tag extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const colorField = 'color';
  late final colorProperty = field<int>(name: colorField)
      .color()
      .withDisplayName('Color')
      .withDefault(() => 0xffff0000)
      .withFallback(() => 0xffff0000);

  static const ownerField = 'owner';
  late final ownerProperty = reference<UserEntity>(name: ownerField).hidden().required();

  @override
  List<ValueObjectBehavior> get behaviors => [
        nameProperty,
        colorProperty,
        ownerProperty,
      ];
}
