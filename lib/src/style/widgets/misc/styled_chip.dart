import 'package:flutter/material.dart';

import '../../emphasis.dart';
import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledChip extends StyledWidget {
  /// The text of the chip.
  final String text;

  /// The icon to display next to [text].
  final IconData? icon;

  /// The color to override the emphasis color of the chip.
  final Color? color;

  /// If non-null, overrides the padding of this chip.
  final EdgeInsets? paddingOverride;

  /// Action to perform when the chip is tapped.
  final void Function()? onTapped;

  final Emphasis emphasis;

  const StyledChip({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    this.paddingOverride,
    required this.onTapped,
    required this.emphasis,
  }) : super(key: key);

  const StyledChip.low({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    this.paddingOverride,
    this.onTapped,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledChip.medium({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    this.paddingOverride,
    this.onTapped,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledChip.high({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    this.paddingOverride,
    this.onTapped,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.chip(context, styleContext, this);
  }
}
