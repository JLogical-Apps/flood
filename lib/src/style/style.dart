import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content_group.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_onboarding_page.dart';
import 'package:jlogical_utils/src/style/widgets/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_content_header_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_subtitle_text.dart';

import 'widgets/content/styled_content.dart';

abstract class Style {
  const Style();

  StyleContext get initialStyleContext;

  // === PAGES ===

  Widget onboardingPage(StyleContext styleContext, StyledOnboardingPage onboardingPage) => throw UnimplementedError();

  // === TEXT ===

  Widget titleText(StyleContext styleContext, StyledTitleText titleText) => throw UnimplementedError();

  Widget subtitleText(StyleContext styleContext, StyledSubtitleText headerText) => throw UnimplementedError();

  Widget contentHeaderText(StyleContext styleContext, StyledContentHeaderText contentHeaderText) =>
      throw UnimplementedError();

  Widget contentSubtitleText(StyleContext styleContext, StyledContentSubtitleText contentSubtitleText) =>
      throw UnimplementedError();

  Widget bodyText(StyleContext styleContext, StyledBodyText bodyText) => throw UnimplementedError();

  Widget buttonText(StyleContext styleContext, StyledButtonText buttonText) => throw UnimplementedError();

  // === INPUT ===
  Widget button(StyleContext styleContext, StyledButton primaryButton) => throw UnimplementedError();

  Widget textField(StyleContext styleContext, StyledTextField textField) => throw UnimplementedError();

  // === CONTENT ===
  Widget content(StyleContext styleContext, StyledContent content) => throw UnimplementedError();

  Widget contentGroup(StyleContext styleContext, StyledCategory contentGroup) => throw UnimplementedError();

  // === MISC ===

  Widget icon(StyleContext styleContext, StyledIcon icon) => throw UnimplementedError();
}
