import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/styled_widget.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';

import '../../style.dart';
import '../../style_context.dart';

class StyledTextSpan extends StyledWidget {
  final List<StyledText> children;
  final TextAlign? textAlign;

  const StyledTextSpan({Key? key, required this.children, required this.textAlign}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.textSpan(context, styleContext, this);
  }
}
