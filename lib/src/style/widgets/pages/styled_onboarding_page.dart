import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/styled_widget.dart';

class StyledOnboardingPage extends StyledWidget {
  final List<OnboardingPageSection> sections;

  final void Function() onComplete;
  final void Function()? onSkip;

  const StyledOnboardingPage({required this.sections, required this.onComplete, this.onSkip});

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.onboardingPage(context, styleContext, this);
  }
}

class OnboardingPageSection {
  final Widget title;
  final Widget description;
  final Widget header;

  const OnboardingPageSection({required this.title, required this.description, required this.header});
}
