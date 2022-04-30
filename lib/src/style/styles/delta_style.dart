import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/style/style_context_provider.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../style_context.dart';
import '../widgets/input/styled_button.dart';
import '../widgets/misc/styled_icon.dart';
import '../widgets/pages/styled_onboarding_page.dart';
import '../widgets/text/styled_body_text.dart';
import '../widgets/text/styled_text_overrides.dart';
import '../widgets/text/styled_title_text.dart';
import 'flat_style.dart';

/// Extends [FlatStyle] with overridden styles.
class DeltaStyle extends FlatStyle {
  /// The accent color that accents the primary color.
  final Color accentColor;

  DeltaStyle({
    Color primaryColor: Colors.green,
    Color backgroundColor: Colors.white,
    this.accentColor: Colors.purple,
  }) : super(
          primaryColor: primaryColor,
          backgroundColor: backgroundColor,
        );

  @override
  Widget onboardingPage(
    BuildContext context,
    StyleContext styleContext,
    StyledOnboardingPage onboardingPage,
  ) {
    return HookBuilder(
      builder: (context) {
        final pageController = useMemoized(() => PageController());
        final page = useState(0);

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [primaryColor.mix(backgroundColorSoft), accentColor.darken()],
                    [
                      backgroundColorSoft.mix(accentColor.darken()).mix(primaryColor),
                      accentColor.lighten().mix(primaryColor)
                    ],
                    [
                      accentColor.darken().mix(backgroundColor).mix(primaryColor).darken(),
                      accentColor.mix(primaryColorSoft).darken()
                    ],
                    [primaryColorSoft.mix(backgroundColorSoft), primaryColor.darken()]
                  ],
                  durations: [70000, 38440, 20800, 12000],
                  heightPercentages: [0.40, 0.43, 0.4, 0.50],
                  blur: MaskFilter.blur(BlurStyle.solid, 10.0),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                size: Size(double.infinity, double.infinity),
              ),
              Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      scrollBehavior: CupertinoScrollBehavior(),
                      allowImplicitScrolling: true,
                      onPageChanged: (_page) => page.value = _page,
                      children: onboardingPage.sections
                          .map((section) => SafeArea(
                                child: Column(
                                  children: [
                                    StyleContextProvider(
                                      styleContext: styleContextFromBackground(backgroundColor),
                                      child: Expanded(
                                        child: Center(
                                            child: section.headerIcon.mapIfNonNull((icon) => StyledIcon.medium(
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
                                      height: 40,
                                    ),
                                    StyleContextProvider(
                                      styleContext: styleContextFromBackground(primaryColor),
                                      child: Expanded(
                                        child: Center(
                                            child: section.bodyText.mapIfNonNull((text) => StyledBodyText(
                                                      text,
                                                      textOverrides: StyledTextOverrides(
                                                        fontSize: 16,
                                                        padding: EdgeInsets.all(12),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )) ??
                                                section.body),
                                        flex: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
              if (onboardingPage.onSkip != null)
                Positioned(
                  bottom: 10,
                  left: 10,
                  width: 100,
                  child: SafeArea(
                    child: animatedFadeIn(
                      isVisible: page.value < onboardingPage.sections.length - 1,
                      child: StyledButton.low(
                        text: 'Skip',
                        onTapped:
                            page.value < onboardingPage.sections.length - 1 ? () => onboardingPage.onSkip!() : null,
                        color: backgroundColor,
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedSmoothIndicator(
                      activeIndex: page.value,
                      count: onboardingPage.sections.length,
                      effect: WormEffect(
                        activeDotColor: backgroundColor,
                        dotColor: styleContext.backgroundColorSoft,
                      ),
                    ),
                  ),
                ),
                bottom: 20,
              ),
              Positioned(
                bottom: 10,
                right: 10,
                width: 100,
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: page.value == onboardingPage.sections.length - 1
                        ? StyledButton.high(
                            key: ValueKey('done'), // Key is needed for AnimatedSwitcher to fade between buttons.
                            text: 'Done',
                            color: backgroundColor,
                            onTapped: onboardingPage.onComplete,
                          )
                        : StyledButton.low(
                            key: ValueKey('next'), // Key is needed for AnimatedSwitcher to fade between buttons.
                            text: 'Next',
                            color: backgroundColor,
                            onTapped: () {
                              pageController.animateToPage(
                                page.value + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
