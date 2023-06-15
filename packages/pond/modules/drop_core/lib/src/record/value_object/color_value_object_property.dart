import 'package:drop_core/drop_core.dart';

class ColorValueObjectProperty<G extends int?, S extends int?, L>
    with IsValueObjectPropertyWrapper<G, S, L, ColorValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final bool isColor;

  ColorValueObjectProperty({required this.property, this.isColor = true});

  @override
  ColorValueObjectProperty<G, S, L> copy() {
    return ColorValueObjectProperty<G, S, L>(property: property.copy(), isColor: isColor);
  }
}
