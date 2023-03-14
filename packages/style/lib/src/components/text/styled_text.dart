import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_body_text.dart';
import 'package:style/src/components/text/styled_button_text.dart';
import 'package:style/src/components/text/styled_h1.dart';
import 'package:style/src/components/text/styled_h2.dart';
import 'package:style/src/components/text/styled_h3.dart';
import 'package:style/src/components/text/styled_h4.dart';
import 'package:style/src/components/text/styled_h5.dart';
import 'package:style/src/components/text/styled_h6.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_component.dart';

abstract class StyledText extends StyleComponent {
  final String text;
  final Emphasis emphasis;

  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? color;
  final bool isError;
  final EdgeInsets? padding;

  StyledText(
    this.text, {
    this.emphasis = Emphasis.regular,
    this.textAlign,
    this.fontWeight,
    this.fontStyle,
    this.color,
    this.isError = false,
    this.padding,
  });

  static StyledTextBuilder<StyledH1> get h1 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledH1(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));

  static StyledTextBuilder<StyledH2> get h2 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledH2(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));

  static StyledTextBuilder<StyledH3> get h3 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledH3(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));

  static StyledTextBuilder<StyledH4> get h4 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledH4(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));

  static StyledTextBuilder<StyledH5> get h5 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledH5(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));

  static StyledTextBuilder<StyledH6> get h6 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledH6(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));

  static StyledTextBuilder<StyledBodyText> get body => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledBodyText(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));

  static StyledTextBuilder<StyledButtonText> get button => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding) => StyledButtonText(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
            padding: padding,
          ));
}
