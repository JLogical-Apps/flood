import 'dart:typed_data';

import 'package:example/pond/domain/user/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class Budget extends ValueObject {
  static const String nameField = 'name';
  late final nameProperty = FieldProperty<String>(name: nameField)
      .withFallback(() => ownerProperty.reference?.value.nameProperty.value)
      .required();

  static const String ownerField = 'owner';
  late final ownerProperty = ReferenceFieldProperty<UserEntity>(name: ownerField);

  late final imagesProperty = ListAssetFieldProperty<ImageAsset, Uint8List>(name: 'images');

  @override
  List<Property> get properties =>
      super.properties +
      [
        nameProperty,
        ownerProperty,
        imagesProperty,
      ];
}
