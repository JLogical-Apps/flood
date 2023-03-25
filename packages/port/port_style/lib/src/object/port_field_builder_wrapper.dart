import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/currency_port_field_builder_wrapper.dart';
import 'package:port_style/src/object/string_port_field_builder_wrapper.dart';
import 'package:utils/utils.dart';

abstract class PortFieldBuilderWrapper with IsWrapper<PortField> {
  Widget? getWidgetOrNull(Port port, String fieldName, PortField portField);

  static final portFieldBuilderWrapperResolver = WrapperResolver<PortFieldBuilderWrapper, PortField>(wrappers: [
    StringPortFieldBuilderWrapper(),
    CurrencyPortFieldBuilderWrapper(),
  ]);

  static PortFieldBuilderWrapper? getPortFieldBuilderWrapper(PortField portField) {
    return portFieldBuilderWrapperResolver.resolveOrNull(portField);
  }
}
