import 'dart:ui';

import 'package:flutter/material.dart';

/// Contains overrides for [StyledText]s. If a value is null, then the value isn't overridden.
class StyledTextOverrides {
  final Color? fontColor;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final int? maxLines;
  final EdgeInsets? padding;
  final List<FontFeature>? fontFeatures;

  const StyledTextOverrides({
    this.fontColor,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.textAlign,
    this.textOverflow,
    this.textDecoration,
    this.maxLines,
    this.padding,
    this.fontFeatures,
  });
}