import 'package:flutter/material.dart';

class StyledTextOverrides {
  final Color? fontColor;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final TextAlign? textAlign;
  final EdgeInsets? padding;

  const StyledTextOverrides({
    this.fontColor,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.textAlign,
    this.padding,
  });
}
