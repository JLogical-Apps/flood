import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledPrimaryButton extends StyledWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  final void Function()? onTap;

  const StyledPrimaryButton({Key? key, required this.text, this.icon, this.color, required this.onTap})
      : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.primaryButton(styleContext, this);
  }
}
