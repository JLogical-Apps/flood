import 'package:jlogical_utils/src/pond/export.dart';

class Envelope extends ValueObject {
  static const namePropertyName = 'name';
  static const amountPropertyName = 'amount';

  late final StringProperty nameProperty = StringProperty(name: namePropertyName);
  late final IntProperty amountProperty = IntProperty(name: amountPropertyName);

  List<Property> get properties => [nameProperty, amountProperty];

  Envelope copyWith({String? name, int? amount}) {
    return Envelope()
      ..nameProperty.value = name ?? nameProperty.value
      ..amountProperty.value = amount ?? amountProperty.value;
  }
}
