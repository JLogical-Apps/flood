import 'package:flutter/material.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledColorPicker extends StyledWidget {
  final Widget? label;
  final String? labelText;

  final Widget? trailing;

  final bool canBeNone;
  final List<Color> allowedColors;

  /// The value of the color field.
  final Color? color;

  /// If not null, then the error associated with this color field.
  final String? errorText;

  /// Action to perform when the color is changed.
  final void Function(Color? value)? onChanged;

  StyledColorPicker({
    this.label,
    this.labelText,
    this.trailing,
    List<Color>? allowedColors,
    this.canBeNone: false,
    this.color,
    this.errorText,
    this.onChanged,
  }) : this.allowedColors = allowedColors ?? Colors.primaries;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.colorPicker(context, styleContext, this);
  }
}
