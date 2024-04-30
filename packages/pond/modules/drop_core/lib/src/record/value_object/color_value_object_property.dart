import 'package:drop_core/drop_core.dart';

class ColorValueObjectProperty<G extends int?, S extends int?>
    with IsValueObjectPropertyWrapper<G, S, ColorValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final bool isColor;

  ColorValueObjectProperty({required this.property, this.isColor = true});

  @override
  ColorValueObjectProperty<G, S> copy() {
    return ColorValueObjectProperty<G, S>(property: property.copy(), isColor: isColor);
  }
}
