import 'package:jlogical_utils/jlogical_utils.dart';

class User extends ValueObject with WithPortGenerator<User> {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final emailProperty = FieldProperty<String>(name: 'email');
  late final phoneNumberProperty = FieldProperty<String>(name: 'phone');
  late final profilePictureProperty = AssetFieldProperty(name: 'profilePicture');
  late final colorProperty = FieldProperty<int>(name: 'color');

  @override
  List<Property> get properties =>
      super.properties +
      [
        nameProperty,
        emailProperty,
        phoneNumberProperty,
        profilePictureProperty,
        colorProperty,
      ];

  @override
  List<PortField> get portFields => [
        nameProperty.toPortField().required(),
        emailProperty.toPortField().required().isEmail(),
        profilePictureProperty.toPortField(),
        colorProperty.toPortField(),
      ];
}
