import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_tab.dart';

class StyledTabbedPage extends StyledWidget {

  final List<StyledTab> pages;

  final String? title;
  final Color? backgroundColor;

  final List<ActionItem>? actions;

  const StyledTabbedPage({
    required this.pages,
    this.title,
    this.backgroundColor,
    this.actions: const [],
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.tabbedPage(context, styleContext, this);
  }
}
