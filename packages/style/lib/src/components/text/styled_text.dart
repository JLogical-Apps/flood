import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

class StyledText extends StyleComponent {
  final String text;
  final Emphasis emphasis;

  final int size;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  final bool isDisplay;
  final Color? color;
  final bool isError;
  final EdgeInsets? padding;

  StyledText(
    this.text, {
    this.size = 18,
    this.emphasis = Emphasis.regular,
    this.textAlign,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.isDisplay = false,
    this.color,
    this.isError = false,
    this.padding,
  });

  static StyledTextBuilder get fourXl => StyledTextBuilder().fourXl;

  static StyledTextBuilder get twoXl => StyledTextBuilder().twoXl;

  static StyledTextBuilder get xl => StyledTextBuilder().xl;

  static StyledTextBuilder get lg => StyledTextBuilder().lg;

  static StyledTextBuilder get body => StyledTextBuilder();

  static StyledTextBuilder get sm => StyledTextBuilder().sm;

  static StyledTextBuilder get xs => StyledTextBuilder().xs;
}
