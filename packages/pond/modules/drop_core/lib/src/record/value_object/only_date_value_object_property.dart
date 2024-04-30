import 'package:drop_core/drop_core.dart';

class OnlyDateValueObjectProperty<G, S> with IsValueObjectPropertyWrapper<G, S, OnlyDateValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final bool onlyDate;

  OnlyDateValueObjectProperty({required this.property, this.onlyDate = true});

  @override
  OnlyDateValueObjectProperty<G, S> copy() {
    return OnlyDateValueObjectProperty<G, S>(
      property: property.copy(),
      onlyDate: onlyDate,
    );
  }
}
