import 'package:jlogical_utils/jlogical_utils.dart';

class Budget extends ValueObject {
  late final StringProperty nameProperty = StringProperty(name: 'name');

  @override
  List<Property> get properties => [nameProperty];
}
