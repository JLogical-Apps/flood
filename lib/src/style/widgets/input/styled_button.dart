import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledButton extends StyledWidget {
  /// The text of the button.
  final String text;

  /// The icon to display next to [text].
  final IconData? icon;

  /// The color to override the emphasis color of the button.
  final Color? color;

  /// Action to perform when the button is tapped.
  final void Function()? onTapped;

  final Emphasis emphasis;

  const StyledButton({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTapped,
    required this.emphasis,
  }) : super(key: key);

  const StyledButton.low({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTapped,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledButton.medium({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTapped,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledButton.high({
    Key? key,
    required this.text,
    this.icon,
    this.color,
    required this.onTapped,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.button(context, styleContext, this);
  }
}
