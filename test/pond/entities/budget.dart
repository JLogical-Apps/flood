import 'package:jlogical_utils/jlogical_utils.dart';

import 'user_entity.dart';

class Budget extends ValueObject {
  late final ownerProperty = ReferenceFieldProperty<UserEntity>(name: 'owner');
  late final nameProperty =
      FieldProperty<String>(name: 'name').withFallback(() => ownerProperty.reference?.value.nameProperty.value);

  @override
  List<Property> get properties => super.properties + [nameProperty, ownerProperty];
}
