import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/emphasis.dart';

class StyledTextBuilder<T extends StyledText> {
  final T Function(
    String text,
    Emphasis emphasis,
    TextAlign? textAlign,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Color? color,
    bool error,
    EdgeInsets? padding,
  ) builder;

  Emphasis emphasis = Emphasis.regular;
  TextAlign? textAlign;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  Color? color;
  bool isError = false;

  StyledTextBuilder({required this.builder});

  StyledTextBuilder get subtle {
    emphasis = Emphasis.subtle;
    return this;
  }

  StyledTextBuilder get strong {
    emphasis = Emphasis.strong;
    return this;
  }

  StyledTextBuilder get bold {
    fontWeight = FontWeight.w600;
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

  StyledTextBuilder get error {
    isError = true;
    return this;
  }

  StyledTextBuilder withColor(Color? color) {
    this.color = color;
    return this;
  }

  T call(String text, {EdgeInsets? padding}) {
    return builder(text, emphasis, textAlign, fontWeight, fontStyle, color, isError, padding);
  }

  T get empty {
    return call('');
  }
}