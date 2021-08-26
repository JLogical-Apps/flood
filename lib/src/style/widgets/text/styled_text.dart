import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

abstract class StyledText extends StyledWidget {
  final String text;
  final Color? fontColorOverride;
  final double? fontSizeOverride;
  final String? fontFamilyOverride;
  final FontWeight? fontWeightOverride;
  final FontStyle? fontStyleOverride;

  const StyledText({
    Key? key,
    required this.text,
    this.fontColorOverride,
    this.fontSizeOverride,
    this.fontFamilyOverride,
    this.fontWeightOverride,
    this.fontStyleOverride,
  }) : super(key: key);
}
