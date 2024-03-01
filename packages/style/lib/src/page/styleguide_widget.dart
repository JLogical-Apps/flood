import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intersperse/intersperse.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/layout/styled_tabs.dart';
import 'package:style/src/components/misc/styled_divider.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/styleguide.dart';

class StyleguideWidget extends HookWidget {
  final Styleguide styleguide;

  const StyleguideWidget({super.key, required this.styleguide});

  @override
  Widget build(BuildContext context) {
    return StyledTabs(
      tabs: styleguide.tabs
          .map((page) => StyledTab(
                titleText: page.name,
                icon: page.icon,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: StyledList.column.withScrollbar(
                      children: page.sections
                          .map<Widget>((section) => StyledList.column(
                                children: [
                                  StyledText.lg.bold.display(section.name),
                                  ...section.widgets,
                                ],
                              ))
                          .intersperse(StyledDivider())
                          .toList()),
                ),
              ))
          .toList(),
    );
  }
}
