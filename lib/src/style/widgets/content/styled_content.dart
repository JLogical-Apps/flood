import 'package:flutter/cupertino.dart';

import '../../../../jlogical_utils.dart';
import '../../style_accent.dart';

class StyledContent extends StyledWidget {
  final StyleAccent styledContentAccent;

  final String? header;
  final String? content;

  final Widget? lead;
  final Widget? trailing;

  final List<Widget> children;

  final void Function()? onTap;

  const StyledContent({
    Key? key,
    this.styledContentAccent: StyleAccent.plain,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.onTap,
    this.children: const [],
  }) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.content(styleContext, this);
  }
}
