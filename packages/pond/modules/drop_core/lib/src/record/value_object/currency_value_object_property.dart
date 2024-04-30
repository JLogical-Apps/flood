import 'package:drop_core/drop_core.dart';

class CurrencyValueObjectProperty<G extends int?, S extends int?>
    with IsValueObjectPropertyWrapper<G, S, CurrencyValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final bool isCurrency;

  CurrencyValueObjectProperty({required this.property, this.isCurrency = true});

  @override
  CurrencyValueObjectProperty<G, S> copy() {
    return CurrencyValueObjectProperty<G, S>(property: property.copy(), isCurrency: isCurrency);
  }
}
