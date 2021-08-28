import 'package:flutter/material.dart';

import '../../../../jlogical_utils.dart';

class StyledIcon extends StyledWidget {
  final IconData iconData;

  final double? size;

  final Color? colorOverride;
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
