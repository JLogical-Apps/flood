import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';

import '../../../../jlogical_utils.dart';

/// Contains contents or other children.
class StyledCategory extends StyledWidget {
  /// The header text to display.
  final String? headerText;

  /// If [headerText] is null, then displays this as the header.
  final Widget? header;

  /// The body text to display underneath the header.
  final String? bodyText;

  /// If [bodyText] is null, then displays this as the body.
  final Widget? body;

  final Widget? leading;
  final Widget? trailing;
  final List<Widget> children;

  /// Widget to display if there are no children.
  final Widget? noChildrenWidget;

  /// Actions that can be performed associated with the category.
  final List<ActionItem> actions;

  /// If non-null, overrides children's emphasis color.
  final Color? emphasisColorOverride;

  /// If non-null, overrides the border radius of the content.
  final BorderRadius? borderRadius;

  /// If non-null, overrides the padding.
  final EdgeInsets? paddingOverride;

  final Emphasis emphasis;

  /// Action to perform when this category is tapped.
  final void Function()? onTapped;

  const StyledCategory({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.noChildrenWidget,
    this.actions: const [],
    this.emphasisColorOverride,
    this.borderRadius,
    this.paddingOverride,
    this.emphasis: Emphasis.low,
    this.onTapped,
  }) : super(key: key);

  const StyledCategory.low({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.noChildrenWidget,
    this.actions: const [],
    this.emphasisColorOverride,
    this.borderRadius,
    this.paddingOverride,
    this.onTapped,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledCategory.medium({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.noChildrenWidget,
    this.actions: const [],
    this.emphasisColorOverride,
    this.borderRadius,
    this.paddingOverride,
    this.onTapped,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledCategory.high({
    Key? key,
    this.headerText,
    this.header,
    this.bodyText,
    this.body,
    this.leading,
    this.trailing,
    this.children: const [],
    this.noChildrenWidget,
    this.actions: const [],
    this.emphasisColorOverride,
    this.borderRadius,
    this.paddingOverride,
    this.onTapped,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.category(context, styleContext, this);
  }
}
