import 'package:port_core/src/port_field.dart';
import 'package:port_core/src/wrapper/base_port_field_wrapper.dart';
import 'package:port_core/src/wrapper/display_name_port_field_wrapper.dart';
import 'package:port_core/src/wrapper/map_port_field_node_wrapper.dart';
import 'package:port_core/src/wrapper/multiline_port_field_wrapper.dart';
import 'package:port_core/src/wrapper/options_port_field_wrapper.dart';
import 'package:port_core/src/wrapper/wrapper_port_field_node_wrapper.dart';
import 'package:utils_core/utils_core.dart';

abstract class PortFieldNodeWrapper<T extends PortField<dynamic, dynamic>>
    with IsTypedWrapper<T, PortField<dynamic, dynamic>> {
  List<R>? getOptionsOrNull<R>(T portField);

  String? getDisplayNameOrNull(T portField);

  bool isMultiline(T portField);

  static final nodeWrapperResolver = WrapperResolver<PortFieldNodeWrapper, PortField>(wrappers: [
    OptionsPortFieldNodeWrapper(),
    DisplayNamePortFieldNodeWrapper(wrapperGetter: getWrapperOrNull),
    MultilinePortFieldNodeWrapper(wrapperGetter: getWrapperOrNull),
    WrapperPortFieldNodeWrapper(wrapperGetter: getWrapperOrNull),
    MapPortFieldNodeWrapper(wrapperGetter: getWrapperOrNull),
    BasePortFieldWrapper(),
  ]);

  static PortFieldNodeWrapper? getWrapperOrNull(PortField portField) {
    return nodeWrapperResolver.resolveOrNull(portField);
  }
}
