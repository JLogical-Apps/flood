import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/layout/styled_carousel.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleCarouselRenderer with IsTypedStyleRenderer<StyledCarousel> {
  @override
  Widget renderTyped(BuildContext context, StyledCarousel component) {
    return HookBuilder(
      builder: (context) {
        final pageController = useMemoized(() => component.pageController ?? PageController());
        final pageState = useState(pageController.initialPage);

        return Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: component.allowUserNavigation ? null : NeverScrollableScrollPhysics(),
                      scrollBehavior: CupertinoScrollBehavior(),
                      onPageChanged: (page) => pageState.value = page,
                      children: component.pages,
                    ),
                  ),
                ],
              ),
            ),
            if (component.showNavigation && component.onSkip != null)
              Positioned(
                bottom: 10,
                left: 10,
                width: 100,
                child: SafeArea(
                  child: animatedFadeIn(
                    isVisible: pageState.value < component.pages.length - 1,
                    child: StyledButton.subtle(
                      labelText: 'Skip',
                      onPressed: pageState.value < component.pages.length - 1 ? () => component.onSkip!() : null,
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSmoothIndicator(
                    activeIndex: pageState.value,
                    count: component.pages.length,
                    effect: WormEffect(
                      activeDotColor: context.colorPalette().foreground.strong,
                      dotColor: context.colorPalette().foreground.subtle,
                    ),
                  ),
                ),
              ),
              bottom: 20,
            ),
            if (component.showNavigation)
              Positioned(
                bottom: 10,
                right: 10,
                width: 100,
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: pageState.value == component.pages.length - 1
                        ? StyledButton.strong(
                            key: ValueKey('done'), // Key is needed for AnimatedSwitcher to fade between buttons.
                            labelText: 'Done',
                            onPressed: component.onComplete,
                          )
                        : StyledButton.subtle(
                            key: ValueKey('next'),
                            labelText: 'Next',
                            onPressed: () {
                              pageController.animateToPage(
                                pageState.value + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                          ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget animatedFadeIn({required bool isVisible, required Widget child}) => AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 400),
        child: child,
      );
}
