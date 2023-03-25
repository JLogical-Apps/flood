import 'package:drop_core/drop_core.dart';

class CurrencyValueObjectProperty<G extends int?, S extends int?, L> with IsValueObjectPropertyWrapper<G, S, L> {
  @override
  final ValueObjectProperty<G, S, L> property;

  final bool isCurrency;

  CurrencyValueObjectProperty({required this.property, this.isCurrency = true});
}
