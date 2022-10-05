import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/styled_widget.dart';

import '../../emphasis.dart';
import '../../style.dart';
import '../../style_context.dart';

class StyledContainer extends StyledWidget {
  final Color? color;
  final double? width;
  final double? height;
  final Widget? child;
  final Emphasis emphasis;

  final BorderRadius? borderRadius;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;

  /// Action to perform when this container is tapped.
  final void Function()? onTapped;

  const StyledContainer({
    super.key,
    this.color,
    this.width,
    this.height,
    this.child,
    this.emphasis: Emphasis.low,
    this.borderRadius,
    this.constraints,
    this.padding,
    this.onTapped,
  });

  const StyledContainer.low({
    super.key,
    this.color,
    this.width,
    this.height,
    this.child,
    this.onTapped,
    this.borderRadius,
    this.constraints,
    this.padding,
  }) : emphasis = Emphasis.low;

  const StyledContainer.medium({
    super.key,
    this.color,
    this.width,
    this.height,
    this.child,
    this.onTapped,
    this.borderRadius,
    this.constraints,
    this.padding,
  }) : emphasis = Emphasis.medium;

  const StyledContainer.high({
    super.key,
    this.color,
    this.width,
    this.height,
    this.child,
    this.onTapped,
    this.borderRadius,
    this.constraints,
    this.padding,
  }) : emphasis = Emphasis.high;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.container(context, styleContext, this);
  }
}
