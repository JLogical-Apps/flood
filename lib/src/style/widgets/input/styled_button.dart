import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledButton extends StyledWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  final void Function()? onTap;

  final Emphasis emphasis;

  const StyledButton({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTap,
    required this.emphasis,
  }) : super(key: key);

  const StyledButton.low({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTap,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledButton.medium({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTap,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledButton.high({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTap,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.button(context, styleContext, this);
  }
}
