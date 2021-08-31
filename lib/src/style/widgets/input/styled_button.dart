import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledButton extends StyledWidget {
  /// The text of the button.
  final String? text;

  /// If [text] is null, displays this instead.
  final Widget? child;

  /// The icon to display next to [text].
  final IconData? icon;

  /// If [icon] is null, displays this instead.
  final Widget? leading;

  /// The color to override the emphasis color of the button.
  final Color? color;

  /// Action to perform when the button is tapped.
  final void Function()? onTapped;

  final Emphasis emphasis;

  const StyledButton({
    Key? key,
    this.text,
    this.child,
    this.icon,
    this.leading,
    this.color,
    required this.onTapped,
    required this.emphasis,
  }) : super(key: key);

  const StyledButton.low({
    Key? key,
    this.text,
    this.child,
    this.icon,
    this.leading,
    this.color,
    required this.onTapped,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledButton.medium({
    Key? key,
    this.text,
    this.child,
    this.icon,
    this.leading,
    this.color,
    required this.onTapped,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledButton.high({
    Key? key,
    this.text,
    this.child,
    this.icon,
    this.leading,
    this.color,
    required this.onTapped,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.button(context, styleContext, this);
  }
}
