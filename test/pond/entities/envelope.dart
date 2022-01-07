import 'package:jlogical_utils/src/pond/export.dart';

class Envelope extends ValueObject {
  static const nameField = 'name';
  static const amountField = 'amount';

  late final nameProperty = FieldProperty<String>(name: nameField);
  late final amountProperty = FieldProperty<int>(name: amountField);

  List<Property> get properties => super.properties + [nameProperty, amountProperty];

  Envelope copy() {
    return Envelope()..copyFrom(this);
  }
}
