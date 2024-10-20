import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/asset_port_field_builder_modifier.dart';
import 'package:port_style/src/object/bool_port_field_builder_modifier.dart';
import 'package:port_style/src/object/color_port_field_builder_modifier.dart';
import 'package:port_style/src/object/currency_port_field_builder_modifier.dart';
import 'package:port_style/src/object/date_time_port_field_builder_modifier.dart';
import 'package:port_style/src/object/double_port_field_builder_modifier.dart';
import 'package:port_style/src/object/embedded_port_field_builder_modifier.dart';
import 'package:port_style/src/object/file_port_field_builder_modifier.dart';
import 'package:port_style/src/object/int_port_field_builder_modifier.dart';
import 'package:port_style/src/object/list_port_field_builder_modifier.dart';
import 'package:port_style/src/object/multi_option_port_field_builder_modifier.dart';
import 'package:port_style/src/object/options_port_field_builder_modifier.dart';
import 'package:port_style/src/object/search_port_field_builder_modifier.dart';
import 'package:port_style/src/object/stage_port_field_builder_modifier.dart';
import 'package:port_style/src/object/string_port_field_builder_modifier.dart';
import 'package:utils/utils.dart';

abstract class PortFieldBuilderModifier with IsModifier<PortField> {
  Widget? getWidgetOrNull(PortField portField);

  static final portFieldBuilderModifierResolver = ModifierResolver<PortFieldBuilderModifier, PortField>(modifiers: [
    AssetPortFieldBuilderModifier(),
    StagePortFieldBuilderModifier(),
    EmbeddedPortFieldBuilderModifier(),
    MultiOptionPortFieldBuilderModifier(),
    OptionsPortFieldBuilderModifier(),
    SearchPortFieldBuilderModifier(),
    ListPortFieldBuilderModifier(),
    StringPortFieldBuilderModifier(),
    CurrencyPortFieldBuilderModifier(),
    ColorPortFieldBuilderModifier(),
    DateTimePortFieldBuilderModifier(),
    DoublePortFieldBuilderModifier(),
    IntPortFieldBuilderModifier(),
    BoolPortFieldBuilderModifier(),
    FilePortFieldBuilderModifier(),
  ]);

  static PortFieldBuilderModifier? getPortFieldBuilderModifier(PortField portField) {
    return portFieldBuilderModifierResolver.resolveOrNull(portField);
  }
}
