import 'package:port_core/src/currency_port_field.dart';
import 'package:port_core/src/modifier/wrapper_port_field_node_modifier.dart';

class CurrencyPortFieldNodeModifier extends WrapperPortFieldNodeModifier<CurrencyPortField> {
  CurrencyPortFieldNodeModifier({required super.modifierGetter});

  @override
  bool isCurrency(CurrencyPortField portField) {
    return portField.isCurrency;
  }
}
