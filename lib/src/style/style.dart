import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_category.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_checkbox.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_onboarding_page.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_page.dart';
import 'package:jlogical_utils/src/style/widgets/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_content_header_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_subtitle_text.dart';

import 'widgets/content/styled_content.dart';

abstract class Style {
  const Style();

  StyleContext get initialStyleContext;

  // === PAGES ===

  Widget page(BuildContext context, StyleContext styleContext, StyledPage styledPage) => throw UnimplementedError();

  Widget onboardingPage(BuildContext context, StyleContext styleContext, StyledOnboardingPage onboardingPage) =>
      throw UnimplementedError();

  // === TEXT ===

  Widget titleText(BuildContext context, StyleContext styleContext, StyledTitleText titleText) =>
      throw UnimplementedError();

  Widget subtitleText(BuildContext context, StyleContext styleContext, StyledSubtitleText headerText) =>
      throw UnimplementedError();

  Widget contentHeaderText(
          BuildContext context, StyleContext styleContext, StyledContentHeaderText contentHeaderText) =>
      throw UnimplementedError();

  Widget contentSubtitleText(
          BuildContext context, StyleContext styleContext, StyledContentSubtitleText contentSubtitleText) =>
      throw UnimplementedError();

  Widget bodyText(BuildContext context, StyleContext styleContext, StyledBodyText bodyText) =>
      throw UnimplementedError();

  Widget buttonText(BuildContext context, StyleContext styleContext, StyledButtonText buttonText) =>
      throw UnimplementedError();

  // === INPUT ===
  Widget button(BuildContext context, StyleContext styleContext, StyledButton primaryButton) =>
      throw UnimplementedError();

  Widget textField(BuildContext context, StyleContext styleContext, StyledTextField textField) =>
      throw UnimplementedError();

  Widget checkbox(BuildContext context, StyleContext styleContext, StyledCheckbox checkbox) =>
      throw UnimplementedError();

  // === CONTENT ===
  Widget content(BuildContext context, StyleContext styleContext, StyledContent content) => throw UnimplementedError();

  Widget contentGroup(BuildContext context, StyleContext styleContext, StyledCategory contentGroup) =>
      throw UnimplementedError();

  // === MISC ===

  Widget icon(BuildContext context, StyleContext styleContext, StyledIcon icon) => throw UnimplementedError();
}
