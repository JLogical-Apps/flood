import 'package:jlogical_utils/src/pond/export.dart';

class Envelope extends ValueObject {
  late final StringProperty nameProperty = StringProperty(name: 'name');
  late final IntProperty amountProperty = IntProperty(name: 'amount');

  List<Property> get properties => [nameProperty, amountProperty];

  Envelope withNameChanged(String newName) {
    return Envelope()
      ..nameProperty.value = newName
      ..amountProperty.value = amountProperty.value;
  }
}
