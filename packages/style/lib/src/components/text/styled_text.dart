import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_body_text.dart';
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

  StyledText(this.text, {this.emphasis = Emphasis.regular, this.textAlign});

  static StyledTextBuilder get h1 => StyledTextBuilder(
      builder: (text, emphasis, textAlign) => StyledH1(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
          ));

  static StyledTextBuilder get h2 => StyledTextBuilder(
      builder: (text, emphasis, textAlign) => StyledH2(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
          ));

  static StyledTextBuilder get h3 => StyledTextBuilder(
      builder: (text, emphasis, textAlign) => StyledH3(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
          ));

  static StyledTextBuilder get h4 => StyledTextBuilder(
      builder: (text, emphasis, textAlign) => StyledH4(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
          ));

  static StyledTextBuilder get h5 => StyledTextBuilder(
      builder: (text, emphasis, textAlign) => StyledH5(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
          ));

  static StyledTextBuilder get h6 => StyledTextBuilder(
      builder: (text, emphasis, textAlign) => StyledH6(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
          ));

  static StyledTextBuilder get body => StyledTextBuilder(
      builder: (text, emphasis, textAlign) => StyledBodyText(
            text,
            emphasis: emphasis,
            textAlign: textAlign,
          ));
}
