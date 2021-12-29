import 'package:example/pond/domain/user/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class Budget extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name')
      .withFallback(() => ownerProperty.reference?.value.nameProperty.value)
      .required();
  late final ownerProperty = ReferenceFieldProperty<UserEntity>(name: 'owner');

  @override
  List<Property> get properties => super.properties + [nameProperty, ownerProperty];

  Budget copyWith({String? name, String? ownerId}) {
    return Budget()
      ..nameProperty.value = name ?? nameProperty.value
      ..ownerProperty.value = ownerId ?? ownerProperty.value;
  }
}
