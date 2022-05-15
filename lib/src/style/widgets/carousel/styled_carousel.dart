import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StyledCarousel extends StyledWidget {
  final List<Widget> children;

  /// A page controller to use, which will allow manual control of the current page.
  /// If none is passed in, creates its own.
  final PageController? pageController;

  /// Whether to show the NEXT and SKIP buttons.
  final bool showNavigation;

  /// Whether to allow the user to swipe between the items.
  final bool allowUserNavigation;

  /// Action to perform when the user completes the onboarding page.
  final void Function()? onComplete;

  /// Action to perform when the user skips the onboarding page.
  final void Function()? onSkip;

  const StyledCarousel({
    super.key,
    required this.children,
    this.pageController,
    this.allowUserNavigation: true,
    this.showNavigation: false,
    this.onComplete,
    this.onSkip,
  });

  @override
  Widget buildStyled(BuildContext context, Style style, StyleContext styleContext) {
    return style.carousel(context, styleContext, this);
  }
}
