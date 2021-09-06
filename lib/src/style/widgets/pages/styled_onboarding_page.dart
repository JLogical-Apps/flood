import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/styled_widget.dart';

class StyledOnboardingPage extends StyledWidget {
  /// Each section is used as a "page" in the onboarding page.
  final List<OnboardingPageSection> sections;

  /// Action to perform when the user completes the onboarding page.
  final void Function() onComplete;

  /// Action to perform when the user skips the onboarding page.
  final void Function()? onSkip;

  const StyledOnboardingPage({required this.sections, required this.onComplete, this.onSkip});

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.onboardingPage(context, styleContext, this);
  }
}

class OnboardingPageSection {
  final IconData? headerIcon;
  final Widget? header;

  final String? titleText;
  final Widget? title;

  final String? bodyText;
  final Widget? body;

  const OnboardingPageSection({
    this.headerIcon,
    this.header,
    this.titleText,
    this.title,
    this.bodyText,
    this.body,
  });
}
