import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';

import '../../../../jlogical_utils.dart';

class StyledCategory extends StyledWidget {
  final String? header;
  final String? content;

  final Widget? lead;
  final Widget? trailing;

  final List<Widget> children;
  final List<ActionItem> actions;

  final Color? emphasisColorOverride;

  final Emphasis emphasis;

  final void Function()? onTap;

  const StyledCategory({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.emphasis: Emphasis.low,
    this.onTap,
  }) : super(key: key);

  const StyledCategory.low({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.onTap,
  }) : emphasis = Emphasis.low;

  const StyledCategory.medium({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.onTap,
  }) : emphasis = Emphasis.medium;

  const StyledCategory.high({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.onTap,
  }) : emphasis = Emphasis.high;

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.category(context, styleContext, this);
  }
}
