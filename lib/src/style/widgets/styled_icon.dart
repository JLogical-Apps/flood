import 'package:flutter/material.dart';

import '../../../jlogical_utils.dart';

class StyledIcon extends StyledWidget {
  final IconData iconData;

  final Color? color;
  final double? size;

  const StyledIcon(this.iconData, {Key? key, this.color, this.size}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.icon(styleContext, this);
  }
}
