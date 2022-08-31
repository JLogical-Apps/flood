import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class CustomStyle extends FlatStyle {
  CustomStyle()
      : super(
          primaryColor: Colors.pink,
          backgroundColor: Colors.black,
        );

  /// Override the TitleText default style.
  @override
  StyledTextStyle titleTextStyle(StyleContext styleContext) => StyledTextStyle(
        fontFamily: 'Arial',
        fontColor: styleContext.emphasisColor,
        fontSize: 36,
        textAlign: TextAlign.center,
        letterSpacing: 2,
        padding: const EdgeInsets.all(7),
        transformer: (text) => text.toUpperCase(),
      );

  /// Use a custom onboarding page for this style.
  /// Copy-paste from [FlatStyle] and make adjustments.
  @override
  Widget onboardingPage(
    BuildContext context,
    StyleContext styleContext, // The [styleContext] includes the current foreground color, background color, etc.
    StyledOnboardingPage onboardingPage, // The [StyledOnboardinPage] to render.
  ) {
    return StyledPage(
      body: StyledCarousel(
        children: onboardingPage.sections
            .map((section) => SafeArea(
                  child: Column(
                    children: [
                      StyleContextProvider(
                        styleContext: styleContextFromBackground(backgroundColor),
                        // Create a StyleContext given a [backgroundColor].
                        child: Expanded(
                          child: Center(
                              child: section.headerIcon.mapIfNonNull((icon) => StyledIcon.high(
                                        icon,
                                        size: 60,
                                      )) ??
                                  section.header),
                          flex: 1,
                        ),
                      ),
                      Expanded(
                        child: Center(
                            child: section.titleText.mapIfNonNull((text) => StyledTitleText(
                                      text,
                                    )) ??
                                section.title),
                        flex: 1,
                      ),
                      SizedBox(
                        height: 20, // <-- I changed this in the CustomStyle!
                      ),
                      Expanded(
                        child: Center(
                            child: section.bodyText.mapIfNonNull((text) => StyledBodyText(
                                      text,
                                    )) ??
                                section.body),
                        flex: 2,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ))
            .toList(),
        onComplete: onboardingPage.onComplete,
        onSkip: onboardingPage.onSkip,
        showNavigation: true,
      ),
    );
  }
}
