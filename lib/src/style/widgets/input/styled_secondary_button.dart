import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledSecondaryButton extends StyledWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  final void Function()? onTap;

  const StyledSecondaryButton({Key? key, required this.text, this.icon, this.color, required this.onTap})
      : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.secondaryButton(styleContext, this);
  }
}
