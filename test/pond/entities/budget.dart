import 'package:jlogical_utils/src/pond/export.dart';

import 'user_entity.dart';

class Budget extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name');
  late final ownerProperty = ReferenceFieldProperty<UserEntity>(name: 'owner');

  @override
  List<Property> get properties => [nameProperty, ownerProperty];
}
