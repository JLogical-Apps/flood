import 'package:jlogical_utils/jlogical_utils.dart';

class Budget extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name');

  @override
  List<Property> get properties => [nameProperty];

  Budget withNameChanged(String newName) {
    return Budget()..nameProperty.value = newName;
  }
}
