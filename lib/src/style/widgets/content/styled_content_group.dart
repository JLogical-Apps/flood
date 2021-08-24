import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/src/style/style_accent.dart';

import '../../../../jlogical_utils.dart';

class StyledContentGroup extends StyledWidget {
  final String? header;
  final String? content;

  final Widget? lead;
  final Widget? trailing;

  final StyleAccent styledContentAccent;

  final void Function()? onTap;

  const StyledContentGroup({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.styledContentAccent: StyleAccent.plain,
    this.onTap,
  }) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.contentGroup(styleContext, this);
  }
}
