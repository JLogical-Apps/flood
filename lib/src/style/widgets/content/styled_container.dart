import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/styled_widget.dart';

import '../../emphasis.dart';
import '../../style.dart';
import '../../style_context.dart';

class StyledContainer extends StyledWidget {
  final Color? color;

  final Widget? child;

  final Emphasis emphasis;

  /// Action to perform when this container is tapped.
  final void Function()? onTapped;

  const StyledContainer({
    super.key,
    this.color,
    this.child,
    this.emphasis: Emphasis.low,
    this.onTapped,
  });

  const StyledContainer.low({
    super.key,
    this.color,
    this.child,
    this.onTapped,
  }) : emphasis = Emphasis.low;

  const StyledContainer.medium({
    super.key,
    this.color,
    this.child,
    this.onTapped,
  }) : emphasis = Emphasis.medium;

  const StyledContainer.high({
    super.key,
    this.color,
    this.child,
    this.onTapped,
  }) : emphasis = Emphasis.high;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.container(context, styleContext, this);
  }
}
