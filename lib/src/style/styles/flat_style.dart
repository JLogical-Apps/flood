import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';
import 'package:jlogical_utils/src/style/emphasis_provider.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content_group.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_button.dart';
import 'package:jlogical_utils/src/style/widgets/styled_icon.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../style_context_provider.dart';

class FlatStyle extends Style {
  final Color primaryColor;
  late final Color primaryColorDarker = TinyColor(primaryColor).darken(40).color;

  final Color accentColor;

  final Color backgroundColor;

  final Color contentBackgroundColor;

  final String titleFontFamily;
  final String subtitleFontFamily;
  final String bodyFontFamily;

  FlatStyle({
    this.primaryColor: Colors.blue,
    this.accentColor: Colors.pink,
    this.backgroundColor: Colors.white,
    Color? contentBackgroundColor,
    this.titleFontFamily: 'Montserrat',
    this.subtitleFontFamily: 'Quicksand',
    this.bodyFontFamily: 'Lato',
  }) : this.contentBackgroundColor =
            contentBackgroundColor ?? (backgroundColor.isLight ? backgroundColor.darken() : backgroundColor.lighten());

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
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: pageController,
                        allowImplicitScrolling: true,
                        scrollBehavior: CupertinoScrollBehavior(),
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
                                  )
                                : StyledButton.low(
                                    text: 'Next',
                                    onTap: () => pageController.animateToPage(
                                      page.value + 1,
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.easeInOutCubic,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                        activeDotColor: primaryColor,
                        dotColor: primaryColorDarker,
                      ),
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

  @override
  Widget titleText(StyleContext styleContext, StyledTitleText titleText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        titleText.text.toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.getFont(titleFontFamily).copyWith(
          color: primaryColor,
          fontSize: 46,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
      ),
    );
  }

  @override
  Widget headerText(StyleContext styleContext, StyledHeaderText headerText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        headerText.text,
        textAlign: TextAlign.center,
        style: GoogleFonts.getFont(subtitleFontFamily).copyWith(
          color: styleContext.isDarkBackground ? Colors.white54 : Colors.black38,
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget contentHeaderText(StyleContext styleContext, StyledContentHeaderText contentHeaderText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        contentHeaderText.text,
        style: GoogleFonts.getFont(subtitleFontFamily).copyWith(
          color: styleContext.isDarkBackground ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget contentSubtitleText(StyleContext styleContext, StyledContentSubtitleText contentSubtitleText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        contentSubtitleText.text,
        style: GoogleFonts.getFont(bodyFontFamily).copyWith(
          color: styleContext.isDarkBackground ? Colors.white70 : Colors.black87,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget bodyText(StyleContext styleContext, StyledBodyText bodyText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        bodyText.text,
        textAlign: TextAlign.left,
        style: GoogleFonts.getFont(bodyFontFamily).copyWith(
          color: styleContext.isDarkBackground ? Colors.white70 : Colors.black87,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget buttonText(StyleContext styleContext, StyledButtonText buttonText) {
    var color = buttonText.textColor;
    if (color == null) {
      final neutralColor = styleContext.isDarkBackground ? Colors.white : Colors.black;
      switch(styleContext.emphasis){
        case Emphasis.high:
          color = neutralColor;
          break;
        case Emphasis.medium:
          color = primaryColor;
          break;
        case Emphasis.low:
          color = primaryColor;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        buttonText.text.toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(color: color),
      ),
    );
  }

  @override
  Widget button(StyleContext styleContext, StyledButton button) {
    final color = button.color ?? primaryColor;
    final neutral = color.isDark ? Colors.white : Colors.black;
    final emphasis = button.emphasis ?? styleContext.emphasis;

    Widget _buttonWidget() {
      switch (emphasis) {
        case Emphasis.high:
          return button.icon == null
              ? ElevatedButton(
                  child: StyledButtonText(button.text),
                  onPressed: button.onTap,
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
                )
              : ElevatedButton.icon(
                  onPressed: button.onTap,
                  icon: StyledIcon(button.icon!),
                  label: StyledButtonText(button.text),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(backgroundColor)),
                );
        case Emphasis.medium:
          return button.icon == null
              ? OutlinedButton(
                  child: StyledButtonText(button.text),
                  onPressed: button.onTap,
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(backgroundColor)),
                )
              : OutlinedButton.icon(
                  onPressed: button.onTap,
                  icon: StyledIcon(button.icon!),
                  label: StyledButtonText(button.text),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(backgroundColor)),
                );
        case Emphasis.low:
          return button.icon == null
              ? OutlinedButton(
                  child: StyledButtonText(button.text),
                  onPressed: button.onTap,
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
                )
              : OutlinedButton.icon(
                  onPressed: button.onTap,
                  icon: StyledIcon(button.icon!),
                  label: StyledButtonText(button.text),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
                );
      }
    }

    return button.emphasis == null
        ? _buttonWidget()
        : EmphasisProvider(
            emphasis: button.emphasis!,
            child: _buttonWidget(),
          );
  }

  @override
  Widget content(StyleContext styleContext, StyledContent content) {
    final cardColor = colorFromStyleAccent(styleContext.emphasis);
    return ClickableCard(
      color: cardColor,
      onTap: content.onTap,
      child: StyleContextProvider(
        styleContext: styleContext.copyWith(backgroundColor: cardColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: content.header == null ? null : StyledContentHeaderText(content.header!),
              subtitle: content.content == null ? null : StyledContentSubtitleText(content.content!),
              leading: content.lead,
              trailing: content.trailing,
            ),
            if (content.children.isNotEmpty) ...[
              Divider(),
              ...content.children,
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget contentGroup(StyleContext styleContext, StyledCategory contentGroup) {
    // TODO: implement contentGroup
    throw UnimplementedError();
  }

  @override
  Widget icon(StyleContext styleContext, StyledIcon icon) {
    final iconColor = icon.color ?? (styleContext.isDarkBackground ? Colors.white : Colors.black);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon.iconData,
        color: iconColor,
        size: icon.size,
      ),
    );
  }

  Widget animatedFadeIn({required bool isVisible, required Widget child}) => AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 400),
        child: child,
      );

  Color colorFromStyleAccent(Emphasis accent) {
    switch (accent) {
      case Emphasis.high:
        return primaryColor;
      case Emphasis.medium:
        return accentColor;
      case Emphasis.low:
        return contentBackgroundColor;
    }
  }
}
