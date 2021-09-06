import 'package:flutter/material.dart';

class StyledTextStyle {
  final String fontFamily;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double letterSpacing;
  final TextAlign textAlign;
  final EdgeInsets padding;
  final String Function(String original)? transformer;

  StyledTextStyle({
    required this.fontFamily,
    required this.fontColor,
    this.fontSize: 12,
    this.fontWeight: FontWeight.normal,
    this.fontStyle: FontStyle.normal,
    this.letterSpacing: 0,
    this.textAlign: TextAlign.left,
    this.padding: const EdgeInsets.all(4),
    this.transformer,
  });

  StyledTextStyle copyWith({
    String? fontFamily,
    Color? fontColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    TextAlign? textAlign,
    EdgeInsets? padding,
  }) {
    return StyledTextStyle(
      fontFamily: fontFamily ?? this.fontFamily,
      fontColor: fontColor ?? this.fontColor,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      textAlign: textAlign ?? this.textAlign,
      padding: padding ?? this.padding,
      transformer: transformer,
    );
  }
}
