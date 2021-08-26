import 'package:flutter/material.dart';

import '../../../jlogical_utils.dart';

class StyledNavBar extends StyledWidget {
  final List<Widget> pages;
  final List<String> pageNames;

  const StyledNavBar({Key? key, required this.pages, required this.pageNames}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.navBar(styleContext, this);
  }
}
