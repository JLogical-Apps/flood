import 'package:flutter/cupertino.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';

import '../../../../jlogical_utils.dart';

class StyledCategory extends StyledWidget {
  final String? header;
  final String? content;

  final Widget? lead;
  final Widget? trailing;

  final Emphasis emphasis;

  final void Function()? onTap;

  const StyledCategory({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.emphasis: Emphasis.low,
    this.onTap,
  }) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.contentGroup(context, styleContext, this);
  }
}
