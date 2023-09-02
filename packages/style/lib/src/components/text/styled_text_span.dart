import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_component.dart';

class StyledTextSpan extends StyleComponent {
  final List<StyledText> text;

  final EdgeInsets? padding;

  StyledTextSpan(
    this.text, {
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
      children: text
          .map((text) => TextSpan(
                text: text.text,
                style: context.style().getTextStyle(context, text),
              ))
          .toList(),
    ));
  }
}
