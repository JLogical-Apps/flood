import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';

class StyledCarousel extends StyleComponent {
  final List<Widget> pages;

  final PageController? pageController;

  final bool showNavigation;

  final bool allowUserNavigation;

  final void Function()? onComplete;
  final String? completeButtonText;
  final String? nextButtonText;

  final void Function()? onSkip;
  final String? skipButtonText;

  StyledCarousel({
    super.key,
    required this.pages,
    this.pageController,
    this.allowUserNavigation = true,
    this.showNavigation = false,
    this.onComplete,
    this.completeButtonText,
    this.nextButtonText,
    this.onSkip,
    this.skipButtonText,
  });
}
