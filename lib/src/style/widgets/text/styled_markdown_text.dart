import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../style.dart';
import '../../style_context.dart';
import '../../styled_widget.dart';
import 'styled_text_overrides.dart';

/// Styled field that parses markdown into a StyledTextSpan.
class StyledMarkdownText extends StyledWidget {
  final String markdown;

  final void Function(String href)? onLinkTapped;

  const StyledMarkdownText({Key? key, required this.markdown, this.onLinkTapped}) : super(key: key);

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return MarkdownBody(
      data: markdown,
      styleSheet: MarkdownStyleSheet(
        p: style.toTextStyle(styledTextStyle: style.bodyTextStyle(styleContext)),
        h1: style.toTextStyle(styledTextStyle: style.titleTextStyle(styleContext)),
        h2: style.toTextStyle(styledTextStyle: style.subtitleTextStyle(styleContext)),
        h3: style.toTextStyle(styledTextStyle: style.contentHeaderTextStyle(styleContext)),
        h4: style.toTextStyle(styledTextStyle: style.contentSubtitleTextStyle(styleContext)),
        code: style
            .toTextStyle(
              styledTextStyle: style.bodyTextStyle(styleContext),
              overrides: StyledTextOverrides(
                fontColor: styleContext.emphasisColor,
                fontWeight: FontWeight.bold,
              ),
            )
            .copyWith(backgroundColor: Colors.transparent),
        // MarkdownBody defaults to a white background for some reason.
        a: style.toTextStyle(
          styledTextStyle: style.bodyTextStyle(styleContext),
          overrides: StyledTextOverrides(
            fontColor: styleContext.emphasisColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ),
      softLineBreak: true,
      onTapLink: (_, href, __) {
        if (href == null) {
          return;
        }
        onLinkTapped.mapIfNonNull((onLinkTapped) => onLinkTapped(href));
      },
    );
  }
}
