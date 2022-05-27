import 'package:flutter/cupertino.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';
import '../input/action_item.dart';

class StyledPage extends StyledWidget {
  /// The title of the page.
  final String? titleText;

  /// If [titleText] is null, display this as the title of the page.
  final Widget? title;

  final Widget body;

  /// If not null, overrides the background of the page.
  final Color? backgroundColor;

  /// Actions that can be performed associated with the page.
  final List<ActionItem> actions;

  /// Callback for when the user refreshes the page.
  final Future<void> Function()? onRefresh;

  /// Whether to indicate the page is loading something.
  final bool isLoading;

  const StyledPage({
    this.titleText,
    this.title,
    required this.body,
    this.backgroundColor,
    this.actions: const [],
    this.onRefresh,
    this.isLoading: false,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.page(context, styleContext, this);
  }
}
