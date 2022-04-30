import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_overrides.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_style.dart';

import '../../style.dart';
import '../../styled_widget.dart';

abstract class StyledText extends StyledWidget {
  final String text;
  final StyledTextOverrides? overrides;

  const StyledText({
    Key? key,
    required this.text,
    this.overrides,
  }) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.text(context, styleContext, this);
  }

  /// The root text style for the text.
  StyledTextStyle getStyle(Style style, StyleContext styleContext);

  Color? get fontColorOverride => overrides?.fontColor;

  double? get fontSizeOverride => overrides?.fontSize;

  String? get fontFamilyOverride => overrides?.fontFamily;

  FontWeight? get fontWeightOverride => overrides?.fontWeight;

  FontStyle? get fontStyleOverride => overrides?.fontStyle;

  double? get letterSpacingOverride => overrides?.letterSpacing;

  TextAlign? get textAlignOverride => overrides?.textAlign;

  TextOverflow? get overflowOverride => overrides?.textOverflow;

  TextDecoration? get decorationOverride => overrides?.textDecoration;

  int? get maxLinesOverride => overrides?.maxLines;

  EdgeInsets? get paddingOverride => overrides?.padding;
}
