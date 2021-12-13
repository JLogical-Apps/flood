import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/property/field_property.dart';

class User extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'Jake');

  @override
  List<Property> get properties => [nameProperty];
}
