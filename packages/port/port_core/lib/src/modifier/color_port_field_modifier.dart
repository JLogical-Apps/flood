import 'package:port_core/src/color_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class ColorPortFieldNodeModifier extends WrapperPortFieldNodeModifier<ColorPortField> {
  ColorPortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isColor(ColorPortField portField) {
    return portField.isColor;
  }
}
