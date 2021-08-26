import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class DeltaStyle extends FlatStyle {
  DeltaStyle({
    Color primaryColor: Colors.green,
    Color accentColor: Colors.purple,
    Color backgroundColor: Colors.white,
    String titleFontFamily: 'Montserrat',
    String subtitleFontFamily: 'Quicksand',
    String bodyFontFamily: 'Lato',
  }) : super(
          primaryColor: primaryColor,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          titleFontFamily: titleFontFamily,
          subtitleFontFamily: subtitleFontFamily,
          bodyFontFamily: bodyFontFamily,
        );

  @override
  StyleContext get initialStyleContext => StyleContext(
        backgroundColor: backgroundColor,
        emphasis: Emphasis.low,
      );

  @override
  Widget onboardingPage(
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
                    [primaryColor, Color(0xEEF44336)],
                    [contentBackgroundColor, Color(0x77E57373)],
                    [accentColor, Color(0x66FF9800)],
                    [accentColor.mix(contentBackgroundColor), Color(0x55FFEB3B)]
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
                                    Expanded(
                                      child: Center(child: section.header),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Center(child: section.title),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Center(child: section.description),
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (onboardingPage.onSkip != null)
                          animatedFadeIn(
                            isVisible: page.value < onboardingPage.sections.length - 1,
                            child: StyledButton.low(
                              text: 'Skip',
                              color: backgroundColor,
                              onTap: page.value < onboardingPage.sections.length - 1
                                  ? () => onboardingPage.onSkip!()
                                  : null,
                            ),
                          ),
                        Expanded(
                          child: Container(),
                        ),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 400),
                          child: page.value == onboardingPage.sections.length - 1
                              ? StyledButton.high(
                                  text: 'Done',
                                  onTap: onboardingPage.onComplete,
                                  color: backgroundColor,
                                )
                              : StyledButton.low(
                                  text: 'Next',
                                  color: backgroundColor,
                                  onTap: page.value < onboardingPage.sections.length - 1
                                      ? () => pageController.animateToPage(
                                            page.value + 1,
                                            duration: Duration(milliseconds: 400),
                                            curve: Curves.easeInOutCubic,
                                          )
                                      : null,
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSmoothIndicator(
                    activeIndex: page.value,
                    count: onboardingPage.sections.length,
                    effect: WormEffect(
                      activeDotColor: backgroundColor,
                      dotColor: contentBackgroundColor,
                    ),
                  ),
                ),
                bottom: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
