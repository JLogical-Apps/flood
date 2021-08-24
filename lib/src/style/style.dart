import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content_group.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_primary_button.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_secondary_button.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_onboarding_page.dart';
import 'package:jlogical_utils/src/style/widgets/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_content_header_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_header_text.dart';

import 'widgets/content/styled_content.dart';

abstract class Style {
  const Style();

  StyleContext get initialStyleContext;

  // === PAGES ===

  Widget onboardingPage(StyleContext styleContext, StyledOnboardingPage onboardingPage);

  // === TEXT ===

  Widget titleText(StyleContext styleContext, StyledTitleText titleText);

  Widget headerText(StyleContext styleContext, StyledHeaderText headerText);

  Widget contentHeaderText(StyleContext styleContext, StyledContentHeaderText contentHeaderText);

  Widget contentSubtitleText(StyleContext styleContext, StyledContentSubtitleText contentSubtitleText);

  Widget bodyText(StyleContext styleContext, StyledBodyText bodyText);

  Widget buttonText(StyleContext styleContext, StyledButtonText buttonText);

  // === INPUT ===

  Widget primaryButton(StyleContext styleContext, StyledPrimaryButton primaryButton);

  Widget secondaryButton(StyleContext styleContext, StyledSecondaryButton secondaryButton);

  // === CONTENT ===
  Widget content(StyleContext styleContext, StyledContent content);

  Widget contentGroup(StyleContext styleContext, StyledContentGroup contentGroup);

  // === MISC ===

  Widget icon(StyleContext styleContext, StyledIcon icon);
}
