import 'package:drop_core/drop_core.dart';

class CurrencyValueObjectProperty<G extends int?, S extends int?, L>
    with IsValueObjectPropertyWrapper<G, S, L, CurrencyValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final bool isCurrency;

  CurrencyValueObjectProperty({required this.property, this.isCurrency = true});

  @override
  CurrencyValueObjectProperty<G, S, L> copy() {
    return CurrencyValueObjectProperty<G, S, L>(property: property.copy(), isCurrency: isCurrency);
  }

  @override
  List<Object?> get props => [property, isCurrency];
}
