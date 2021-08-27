import 'package:flutter/material.dart';

import '../../../../jlogical_utils.dart';

class StyledContent extends StyledWidget {
  final String? header;
  final String? content;

  final Widget? lead;
  final Widget? trailing;

  final List<Widget> children;

  final void Function()? onTap;

  final Emphasis emphasis;

  const StyledContent({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.onTap,
    required this.emphasis,
  }) : super(key: key);

  const StyledContent.low({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.onTap,
  })  : emphasis = Emphasis.low,
        super(key: key);

  const StyledContent.medium({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.onTap,
  })  : emphasis = Emphasis.medium,
        super(key: key);

  const StyledContent.high({
    Key? key,
    this.header,
    this.content,
    this.lead,
    this.trailing,
    this.children: const [],
    this.onTap,
  })  : emphasis = Emphasis.high,
        super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.content(styleContext, this);
  }
}
