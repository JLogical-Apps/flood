import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/style_context_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class DeltaStyle extends FlatStyle {
  final Color accentColor;

  DeltaStyle({
    Color primaryColor: Colors.green,
    Color backgroundColor: Colors.white,
    this.accentColor: Colors.purple,
    String titleFontFamily: 'Montserrat',
    String subtitleFontFamily: 'Quicksand',
    String bodyFontFamily: 'Lato',
  }) : super(
          primaryColor: primaryColor,
          backgroundColor: backgroundColor,
          titleFontFamily: titleFontFamily,
          subtitleFontFamily: subtitleFontFamily,
          bodyFontFamily: bodyFontFamily,
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
                    [primaryColor, Color(0xEEF44336)],
                    [backgroundColorSoft.mix(accentColor), Color(0x77E57373)],
                    [accentColor.compliment.mix(backgroundColor).darken(), Color(0x66FF9800)],
                    [primaryColorSoft.mix(backgroundColorSoft).darken(), Color(0x55FFEB3B)]
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
                                        child: Center(child: section.header),
                                        flex: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(child: section.title),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Center(child: section.description),
                                      flex: 2,
                                    ),
                                    SizedBox(
                                      height: 55,
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
                        onTap: page.value < onboardingPage.sections.length - 1 ? () => onboardingPage.onSkip!() : null,
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
                            onTap: onboardingPage.onComplete,
                          )
                        : StyledButton.low(
                            key: ValueKey('next'),
                            text: 'Next',
                            color: backgroundColor,
                            onTap: () => pageController.animateToPage(
                              page.value + 1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                            ),
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
