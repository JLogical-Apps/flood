import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/emphasis.dart';

class StyledTextBuilder {
  Emphasis emphasis = Emphasis.regular;
  TextAlign? textAlign;
  int? size;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  bool? isDisplay;
  Color? color;
  bool isError = false;

  StyledTextBuilder get subtle {
    emphasis = Emphasis.subtle;
    return this;
  }

  StyledTextBuilder get strong {
    emphasis = Emphasis.strong;
    return this;
  }

  StyledTextBuilder get xs {
    size = 12;
    return this;
  }

  StyledTextBuilder get sm {
    size = 16;
    return this;
  }

  StyledTextBuilder get lg {
    size = 22;
    return this;
  }

  StyledTextBuilder get xl {
    size = 28;
    return this;
  }

  StyledTextBuilder get twoXl {
    size = 48;
    return this;
  }

  StyledTextBuilder get fourXl {
    size = 72;
    return this;
  }

  StyledTextBuilder get bold {
    fontWeight = FontWeight.w600;
    return this;
  }

  StyledTextBuilder get semiBold {
    fontWeight = FontWeight.w500;
    return this;
  }

  StyledTextBuilder get thin {
    fontWeight = FontWeight.w200;
    return this;
  }

  StyledTextBuilder get centered {
    textAlign = TextAlign.center;
    return this;
  }

  StyledTextBuilder get leftAligned {
    textAlign = TextAlign.left;
    return this;
  }

  StyledTextBuilder get rightAligned {
    textAlign = TextAlign.right;
    return this;
  }

  StyledTextBuilder get italics {
    fontStyle = FontStyle.italic;
    return this;
  }

  StyledTextBuilder get display {
    isDisplay = true;
    return this;
  }

  StyledTextBuilder get error {
    isError = true;
    return this;
  }

  StyledTextBuilder withColor(Color? color) {
    this.color = color;
    return this;
  }

  StyledText call(String text, {EdgeInsets? padding}) {
    return StyledText(
      text,
      emphasis: emphasis,
      size: size ?? 18,
      textAlign: textAlign,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      isDisplay: isDisplay ?? false,
      color: color,
      isError: isError,
      padding: padding,
    );
  }

  StyledText get empty {
    return call('');
  }
}
