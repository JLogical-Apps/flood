import 'package:jlogical_utils/jlogical_utils.dart';

class User extends ValueObject {
  late final StringProperty nameProperty = StringProperty(name: 'Jake');

  @override
  List<Property> get properties => [nameProperty];
}
