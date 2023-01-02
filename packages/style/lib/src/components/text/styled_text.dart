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
  final FontStyle? fontStyle;
  final Color? color;
  final bool isError;

  StyledText(
    this.text, {
    this.emphasis = Emphasis.regular,
    this.textAlign,
    this.fontStyle,
    this.color,
    this.isError = false,
  });

  static StyledTextBuilder<StyledH1> get h1 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledH1(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));

  static StyledTextBuilder<StyledH2> get h2 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledH2(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));

  static StyledTextBuilder<StyledH3> get h3 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledH3(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));

  static StyledTextBuilder<StyledH4> get h4 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledH4(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));

  static StyledTextBuilder<StyledH5> get h5 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledH5(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));

  static StyledTextBuilder<StyledH6> get h6 => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledH6(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));

  static StyledTextBuilder<StyledBodyText> get body => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledBodyText(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));

  static StyledTextBuilder<StyledButtonText> get button => StyledTextBuilder(
      builder: (text, emphasis, textAlign, fontStyle, color, isError) => StyledButtonText(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
            fontStyle: fontStyle,
            color: color,
            isError: isError,
          ));
}
