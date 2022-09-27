import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_tab.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';
import '../input/action_item.dart';

class StyledTabbedPage extends StyledWidget {
  /// The pages that will be displayed as tabs in this page.
  final List<StyledTab> pages;

  /// Overrides displaying the currently selected tab's title.
  final String? title;

  /// If not null, overrides the background color of the page.
  final Color? backgroundColor;

  /// If not null, overrides the background color of the tabs.
  final Color? tabsColor;

  /// Overrides the currently selected tab's actions.
  final List<ActionItem>? actions;

  /// Whether to hide the header.
  /// This is overridden if either the StyledTabbedPage or StyledTabs have [actions]
  /// to be displayed.
  final bool hideHeader;

  const StyledTabbedPage({
    required this.pages,
    this.title,
    this.backgroundColor,
    this.tabsColor,
    this.actions,
    this.hideHeader: false,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.tabbedPage(context, styleContext, this);
  }
}
