import 'package:flutter/material.dart';

import '../../../../jlogical_utils.dart';

class StyledContent extends StyledWidget {
  /// The header text to display.
  final String? headerText;

  /// If [headerText] is null, then displays this as the header.
  final Widget? header;

  /// The body text to display underneath the header.
  final String? bodyText;

  /// If [bodyText] is null, then displays this as the body.
  final Widget? body;

  /// Displays this before the [header] and [body].
  final Widget? leading;

  /// Displays this after the [header] and [body].
  final Widget? trailing;

  /// Children to display under the header.
  final List<Widget> children;

  /// Actions that can be performed associated with the category.
  final List<ActionItem> actions;

  /// If non-null, overrides children's emphasis color.
  final Color? emphasisColorOverride;

  final Emphasis emphasis;

  /// Action to perform when this category is tapped.
  final void Function()? onTapped;

  const StyledContent({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.emphasis: Emphasis.low,
    this.onTapped,
  }) : super(key: key);

  const StyledContent.low({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.onTapped,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledContent.medium({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.onTapped,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledContent.high({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.actions: const [],
    this.emphasisColorOverride,
    this.onTapped,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.content(context, styleContext, this);
  }
}
