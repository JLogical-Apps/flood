import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/emphasis.dart';

class StyledTextBuilder<T extends StyledText> {
  final T Function(
    String text,
    Emphasis emphasis,
    TextAlign? textAlign,
  ) builder;

  Emphasis emphasis = Emphasis.regular;
  TextAlign? textAlign;

  StyledTextBuilder({required this.builder});

  StyledTextBuilder get subtle {
    emphasis = Emphasis.subtle;
    return this;
  }

  StyledTextBuilder get strong {
    emphasis = Emphasis.strong;
    return this;
  }

  StyledTextBuilder get centered {
    textAlign = TextAlign.center;
    return this;
  }

  T call(String text) {
    return builder(text, emphasis, textAlign);
  }
}
