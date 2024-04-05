import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:utils/utils.dart';

class StyledMarkdown extends StatelessWidget {
  final String markdown;
  final WrapAlignment? textAlign;
  final void Function(String href)? onLinkTapped;
  final StyledTextBuilder baseTextBuilder;
  final StyledTextBuilder Function(StyledTextBuilder text) textModifier;

  StyledMarkdown(
    this.markdown, {
    super.key,
    this.textAlign,
    this.onLinkTapped,
    StyledTextBuilder? baseTextBuilder,
    StyledTextBuilder Function(StyledTextBuilder text)? textModifier,
  })  : baseTextBuilder = baseTextBuilder ?? StyledText.body,
        textModifier = textModifier ?? _defaultTextModifier;

  @override
  Widget build(BuildContext context) {
    final style = context.style();
    return MarkdownBody(
      data: markdown,
      styleSheet: MarkdownStyleSheet(
        textAlign: textAlign ?? WrapAlignment.start,
        p: style.getTextStyle(context, textModifier(baseTextBuilder).empty),
        h1: style.getTextStyle(context, textModifier(StyledText.fourXl).empty),
        h2: style.getTextStyle(context, textModifier(StyledText.twoXl).empty),
        h3: style.getTextStyle(context, textModifier(StyledText.xl).empty),
        h4: style.getTextStyle(context, textModifier(StyledText.body).empty),
        h5: style.getTextStyle(context, textModifier(StyledText.sm).empty),
        h6: style.getTextStyle(context, textModifier(StyledText.xs).empty),
        code: style
            .getTextStyle(context, textModifier(baseTextBuilder).strong.empty)
            .copyWith(backgroundColor: Colors.transparent),
        a: style
            .getTextStyle(context, textModifier(baseTextBuilder).strong.underline.empty)
            .copyWith(decoration: TextDecoration.underline, decorationColor: context.colorPalette().foreground.strong),
      ),
      softLineBreak: true,
      onTapLink: (_, href, __) {
        if (href == null) {
          return;
        }
        onLinkTapped?.mapIfNonNull((onLinkTapped) => onLinkTapped(href));
      },
    );
  }
}

StyledTextBuilder _defaultTextModifier(StyledTextBuilder text) {
  return text;
}
