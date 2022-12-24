import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/layout/styled_tabs.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/styleguide.dart';

class StyleguideWidget extends HookWidget {
  final Styleguide styleguide;

  const StyleguideWidget({super.key, required this.styleguide});

  @override
  Widget build(BuildContext context) {
    return StyledTabs(
      tabs: styleguide.pages
          .map((page) => StyledTab(
                titleText: page.name,
                icon: page.icon,
                child: StyledList.column.withScrollbar(
                    children: page.sections
                        .map((section) => StyledList.column(
                              children: [
                                StyledText.h1(section.name),
                                ...section.widgets,
                              ],
                            ))
                        .toList()),
              ))
          .toList(),
    );
  }
}
