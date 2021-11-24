import 'package:jlogical_utils/src/pond/export.dart';

import 'user.dart';
import 'user_entity.dart';

class Budget extends ValueObject {
  late final StringProperty nameProperty = StringProperty(name: 'name');
  late final ReferenceProperty<UserEntity> ownerProperty = ReferenceProperty(name: 'owner');

  @override
  List<Property> get properties => [nameProperty, ownerProperty];
}
