import 'package:jlogical_utils/jlogical_utils.dart';

class User extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final emailProperty = FieldProperty<String>(name: 'email').required();

  List<Property> get properties => super.properties + [nameProperty, emailProperty];
}
