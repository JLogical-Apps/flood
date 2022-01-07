import 'package:jlogical_utils/src/pond/export.dart';

class Envelope extends ValueObject {
  static const namePropertyName = 'name';
  static const amountPropertyName = 'amount';

  late final nameProperty = FieldProperty<String>(name: namePropertyName);
  late final amountProperty = FieldProperty<int>(name: amountPropertyName);

  List<Property> get properties => [nameProperty, amountProperty];

  Envelope copy() {
    return Envelope()..copyFrom(this);
  }
}
