import 'package:jlogical_utils/src/pond/export.dart';

import 'user_entity.dart';

class Budget extends ValueObject {
  late final ownerProperty = ReferenceFieldProperty<UserEntity>(name: 'owner');
  late final nameProperty =
      FieldProperty<String>(name: 'name').withFallback(() => ownerProperty.reference?.value.nameProperty.value);

  @override
  List<Property> get properties => [nameProperty, ownerProperty];
}
