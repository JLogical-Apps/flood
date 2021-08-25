import 'package:flutter/material.dart';

import '../../../../jlogical_utils.dart';

class StyledContent extends StyledWidget {
  final String? header;
  final String? content;

  final Widget? lead;
  final Widget? trailing;

  final List<Widget> children;

  final void Function()? onTap;

  const StyledContent({
    Key? key,
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
