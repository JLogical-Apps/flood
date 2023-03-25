import 'package:port_core/src/currency_port_field.dart';
import 'package:port_core/src/wrapper/wrapper_port_field_node_wrapper.dart';

class CurrencyPortFieldNodeWrapper extends WrapperPortFieldNodeWrapper<CurrencyPortField> {
  CurrencyPortFieldNodeWrapper({required super.wrapperGetter});

  @override
  bool isCurrency(CurrencyPortField portField) {
    return portField.isCurrency;
  }
}
