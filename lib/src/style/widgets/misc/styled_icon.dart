import 'package:flutter/material.dart';

import '../../emphasis.dart';
import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledIcon extends StyledWidget {
  final IconData iconData;

  /// The size of the icon. If null, a default value is used.
  final double? size;

  /// If not null, overrides the color of the icon.
  final Color? colorOverride;

  /// If not null, overrides the padding of the icon.
  final EdgeInsets? paddingOverride;

  final Emphasis emphasis;

  const StyledIcon(
    this.iconData, {
    Key? key,
    this.size,
    this.colorOverride,
    this.paddingOverride,
    this.emphasis: Emphasis.medium,
  }) : super(key: key);

  const StyledIcon.low(
    this.iconData, {
    Key? key,
    this.size,
    this.colorOverride,
    this.paddingOverride,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledIcon.medium(
    this.iconData, {
    Key? key,
    this.size,
    this.colorOverride,
    this.paddingOverride,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledIcon.high(
    this.iconData, {
    Key? key,
    this.size,
    this.colorOverride,
    this.paddingOverride,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.icon(context, styleContext, this);
  }
}
