import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';

class StyledDivider extends StyledWidget {
  final Emphasis emphasis;
  final double? thickness;
  final Color? colorOverride;

  const StyledDivider({super.key, this.emphasis: Emphasis.medium, this.thickness, this.colorOverride});

  const StyledDivider.low({super.key, this.thickness, this.colorOverride}) : emphasis = Emphasis.low;
  const StyledDivider.medium({super.key, this.thickness, this.colorOverride}) : emphasis = Emphasis.medium;
  const StyledDivider.high({super.key, this.thickness, this.colorOverride}) : emphasis = Emphasis.high;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.divider(context, styleContext, this);
  }
}
