import 'package:jlogical_utils/jlogical_utils.dart';

class User extends ValueObject with WithPortGenerator<User> {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final emailProperty = FieldProperty<String>(name: 'email').required();
  late final profilePictureProperty = AssetFieldProperty(name: 'profilePicture');

  @override
  List<Property> get properties => super.properties + [nameProperty, emailProperty, profilePictureProperty];

  @override
  List<PortField> get portFields => [
        nameProperty.toPortField().required(),
        emailProperty.toPortField().required().isEmail(),
        profilePictureProperty.toPortField(),
      ];
}
