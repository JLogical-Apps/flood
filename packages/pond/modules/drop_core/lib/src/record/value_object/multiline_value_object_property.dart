import 'package:drop_core/drop_core.dart';

class MultilineValueObjectProperty<G extends String?, S extends String?, L>
    with IsValueObjectPropertyWrapper<G, S, L, MultilineValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final bool isMultiline;

  MultilineValueObjectProperty({required this.property, this.isMultiline = true});

  @override
  MultilineValueObjectProperty<G, S, L> copy() {
    return MultilineValueObjectProperty<G, S, L>(property: property.copy(), isMultiline: isMultiline);
  }

  @override
  List<Object?> get props => [property, isMultiline];
}
