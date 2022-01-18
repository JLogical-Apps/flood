import 'package:jlogical_utils/jlogical_utils.dart';

class User extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name');

  @override
  List<Property> get properties => [nameProperty];
}