import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledPage extends StyledWidget {
  /// The title of the page.
  final String? title;

  final Widget body;

  /// If not null, overrides the background of the page.
  final Color? backgroundColor;

  /// Actions that can be performed associated with the page.
  final List<ActionItem> actions;

  /// Callback for when the user refreshes the page.
  final Future<void> Function()? onRefresh;

  const StyledPage({this.title, required this.body, this.backgroundColor, this.actions: const [], this.onRefresh});

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.page(context, styleContext, this);
  }
}
