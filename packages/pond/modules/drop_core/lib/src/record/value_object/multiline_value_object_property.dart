import 'package:drop_core/drop_core.dart';

class MultilineValueObjectProperty<G extends String?, S extends String?>
    with IsValueObjectPropertyWrapper<G, S, MultilineValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final bool isMultiline;

  MultilineValueObjectProperty({required this.property, this.isMultiline = true});

  @override
  MultilineValueObjectProperty<G, S> copy() {
    return MultilineValueObjectProperty<G, S>(property: property.copy(), isMultiline: isMultiline);
  }
}
