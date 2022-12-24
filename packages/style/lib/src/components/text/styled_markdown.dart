import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:utils_core/utils_core.dart';

class StyledMarkdown extends StatelessWidget {
  final String markdown;
  final WrapAlignment? textAlign;
  final void Function(String href)? onLinkTapped;

  StyledMarkdown(this.markdown, {this.textAlign, this.onLinkTapped});

  @override
  Widget build(BuildContext context) {
    final style = context.style();
    return MarkdownBody(
      data: markdown,
      styleSheet: MarkdownStyleSheet(
        textAlign: textAlign ?? WrapAlignment.start,
        p: style.getTextStyle(context, StyledText.body.empty),
        h1: style.getTextStyle(context, StyledText.h1.empty),
        h2: style.getTextStyle(context, StyledText.h2.empty),
        h3: style.getTextStyle(context, StyledText.h3.empty),
        h4: style.getTextStyle(context, StyledText.h4.empty),
        h5: style.getTextStyle(context, StyledText.h5.empty),
        h6: style.getTextStyle(context, StyledText.h6.empty),
        code: style.getTextStyle(context, StyledText.body.strong.empty).copyWith(backgroundColor: Colors.transparent),
        a: style.getTextStyle(context, StyledText.body.strong.empty).copyWith(decoration: TextDecoration.underline),
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
