import 'package:drop_core/drop_core.dart';

class OnlyDateValueObjectProperty<G, S, L>
    with IsValueObjectPropertyWrapper<G, S, L, OnlyDateValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final bool onlyDate;

  OnlyDateValueObjectProperty({required this.property, this.onlyDate = true});

  @override
  OnlyDateValueObjectProperty<G, S, L> copy() {
    return OnlyDateValueObjectProperty<G, S, L>(
      property: property.copy(),
      onlyDate: onlyDate,
    );
  }

  @override
  List<Object?> get props => [property, onlyDate];
}
