import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledPage extends StyledWidget {
  final String? title;
  final Widget body;

  final List<ActionItem> actions;

  const StyledPage({
    this.title,
    required this.body,
    this.actions: const [],
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.page(context, styleContext, this);
  }
}
