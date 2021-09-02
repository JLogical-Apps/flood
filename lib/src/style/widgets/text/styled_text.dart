import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_overrides.dart';

abstract class StyledText extends StyledWidget {
  final String text;
  final StyledTextOverrides? overrides;

  const StyledText({
    Key? key,
    required this.text,
    this.overrides,
  }) : super(key: key);

  Color? get fontColorOverride => overrides?.fontColor;

  double? get fontSizeOverride => overrides?.fontSize;

  String? get fontFamilyOverride => overrides?.fontFamily;

  FontWeight? get fontWeightOverride => overrides?.fontWeight;

  FontStyle? get fontStyleOverride => overrides?.fontStyle;

  double? get letterSpacingOverride => overrides?.letterSpacing;

  TextAlign? get textAlignOverride => overrides?.textAlign;

  TextOverflow? get overflowOverride => overrides?.textOverflow;

  int? get maxLinesOverride => overrides?.maxLines;

  EdgeInsets? get paddingOverride => overrides?.padding;
}
