import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/field_property.dart';

import 'user_entity.dart';

class Budget extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name');
  late final ReferenceProperty<UserEntity> ownerProperty = ReferenceProperty(name: 'owner');

  @override
  List<Property> get properties => [nameProperty, ownerProperty];
}
