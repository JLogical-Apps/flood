import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content_group.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_button.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../style_context_provider.dart';

class FlatStyle extends Style {
  final Color primaryColor;
  final Color primaryColorSoft;

  final Color accentColor;
  final Color accentColorSoft;

  final Color backgroundColor;
  final Color backgroundColorSoft;

  final String titleFontFamily;
  final String subtitleFontFamily;
  final String bodyFontFamily;

  FlatStyle({
    this.primaryColor: Colors.blue,
    Color? primaryColorSoft,
    this.accentColor: Colors.pink,
    Color? accentColorSoft,
    this.backgroundColor: Colors.white,
    Color? backgroundColorSoft,
    this.titleFontFamily: 'Montserrat',
    this.subtitleFontFamily: 'Quicksand',
    this.bodyFontFamily: 'Lato',
  })  : this.primaryColorSoft = primaryColorSoft ?? softenColor(primaryColor),
        this.accentColorSoft = accentColorSoft ?? softenColor(accentColor),
        this.backgroundColorSoft = backgroundColorSoft ?? softenColor(backgroundColor);

  @override
  StyleContext get initialStyleContext => styleContextFromBackground(backgroundColor);

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
                  ],
                ),
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
                        activeDotColor: primaryColor,
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
                            onTap: onboardingPage.onComplete,
                          )
                        : StyledButton.low(
                            key: ValueKey('next'),
                            text: 'Next',
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

  Widget rawStyledText({
    required StyledText styledText,
    required String fontFamily,
    String? text,
    Color? fontColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    TextAlign? textAlign,
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: styledText.paddingOverride ?? padding ?? EdgeInsets.zero,
      child: Text(
        text ?? styledText.text,
        textAlign: styledText.textAlignOverride ?? textAlign,
        style: GoogleFonts.getFont(styledText.fontFamilyOverride ?? fontFamily).copyWith(
          color: styledText.fontColorOverride ?? fontColor,
          fontSize: styledText.fontSizeOverride ?? fontSize,
          fontWeight: styledText.fontWeightOverride ?? fontWeight,
          letterSpacing: styledText.letterSpacingOverride ?? letterSpacing,
        ),
      ),
    );
  }

  @override
  Widget titleText(StyleContext styleContext, StyledTitleText titleText) {
    return rawStyledText(
      styledText: titleText,
      text: titleText.text.toUpperCase(),
      fontFamily: titleFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: primaryColor,
      fontSize: 48,
      textAlign: TextAlign.center,
      letterSpacing: 3,
    );
  }

  @override
  Widget subtitleText(StyleContext styleContext, StyledSubtitleText subtitleText) {
    return rawStyledText(
      styledText: subtitleText,
      fontFamily: subtitleFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.foregroundColor,
      fontSize: 28,
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget contentHeaderText(StyleContext styleContext, StyledContentHeaderText contentHeaderText) {
    return rawStyledText(
      styledText: contentHeaderText,
      fontFamily: subtitleFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.primaryColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget contentSubtitleText(StyleContext styleContext, StyledContentSubtitleText contentSubtitleText) {
    return rawStyledText(
      styledText: contentSubtitleText,
      fontFamily: bodyFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.foregroundColorSoft,
      fontSize: 16,
    );
  }

  @override
  Widget bodyText(StyleContext styleContext, StyledBodyText bodyText) {
    return rawStyledText(
      styledText: bodyText,
      fontFamily: bodyFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.foregroundColor,
      fontSize: 18,
    );
  }

  @override
  Widget buttonText(StyleContext styleContext, StyledButtonText buttonText) {
    return rawStyledText(
      styledText: buttonText,
      text: buttonText.text.toUpperCase(),
      fontFamily: bodyFontFamily,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.center,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.foregroundColor,
      fontSize: 12,
      letterSpacing: 1,
    );
  }

  @override
  Widget button(StyleContext styleContext, StyledButton button) {
    return button.emphasis.map(
      high: () {
        final backgroundColor = button.color ?? styleContext.primaryColor;
        return StyleContextProvider(
          styleContext: styleContextFromBackground(backgroundColor),
          child: button.icon == null
              ? ElevatedButton(
                  child: StyledButtonText(button.text),
                  onPressed: button.onTap,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.primaryColor),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: button.onTap,
                  icon: StyledIcon(button.icon!),
                  label: StyledButtonText(button.text),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.primaryColor),
                  ),
                ),
        );
      },
      medium: () {
        return StyleContextProvider(
          styleContext: styleContextFromBackground(backgroundColor),
          child: button.icon == null
              ? ElevatedButton(
                  child: StyledButtonText(button.text),
                  onPressed: button.onTap,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.backgroundColorSoft),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: button.onTap,
                  icon: StyledIcon(button.icon!),
                  label: StyledButtonText(button.text),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.backgroundColorSoft),
                  ),
                ),
        );
      },
      low: () {
        return button.icon == null
            ? TextButton(
                child: StyledButtonText(
                  button.text,
                  textOverrides: StyledTextOverrides(fontColor: button.color ?? styleContext.primaryColor),
                ),
                onPressed: button.onTap,
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
              )
            : TextButton.icon(
                onPressed: button.onTap,
                icon: StyledIcon(button.icon!, color: button.color ?? styleContext.primaryColor),
                label: StyledButtonText(
                  button.text,
                  textOverrides: StyledTextOverrides(fontColor: button.color ?? styleContext.primaryColor),
                ),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
              );
      },
    );
  }

  @override
  Widget textField(StyleContext styleContext, StyledTextField textField) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (textField.label != null) StyledContentSubtitleText(textField.label!),
          TextFormField(
            initialValue: textField.initialValue,
            style: GoogleFonts.getFont(bodyFontFamily).copyWith(
              color: styleContext.foregroundColor,
            ),
            decoration: InputDecoration(
              prefixIcon: textField.leading,
              suffixIcon: textField.trailing,
              fillColor: styleContext.backgroundColorSoft,
              filled: true,
              errorText: textField.errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 0.5,
                  color: styleContext.foregroundColorSoft,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 1,
                  color: primaryColor,
                ),
              ),
            ),
            cursorColor: primaryColor,
            onTap: textField.onTap,
            onChanged: textField.onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget content(StyleContext styleContext, StyledContent content) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClickableCard(
        color: styleContext.backgroundColorSoft,
        onTap: content.onTap,
        child: StyleContextProvider(
          styleContext: styleContextFromBackground(styleContext.backgroundColorSoft),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon.iconData,
        color: icon.color ?? styleContext.foregroundColor,
        size: icon.size,
      ),
    );
  }

  Widget animatedFadeIn({required bool isVisible, required Widget child}) => AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 400),
        child: child,
      );

  static Color softenColor(Color color) {
    return color.computeLuminance() < 0.5 ? color.lighten() : color.darken(15);
  }

  Color getSoftenedColor(Color color) {
    if (color == primaryColor)
      return primaryColorSoft;
    else if (color == primaryColorSoft)
      return primaryColor;
    else if (color == accentColor)
      return accentColorSoft;
    else if (color == accentColorSoft)
      return accentColor;
    else if (color == backgroundColor)
      return backgroundColorSoft;
    else if (color == backgroundColorSoft)
      return backgroundColor;
    else
      return softenColor(color);
  }

  StyleContext styleContextFromBackground(Color backgroundColor) {
    final foregroundColor = backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    return StyleContext(
      backgroundColor: backgroundColor,
      backgroundColorSoft: getSoftenedColor(backgroundColor),
      foregroundColor: foregroundColor,
      foregroundColorSoft: getSoftenedColor(foregroundColor),
      primaryColor: primaryColor,
      primaryColorSoft: getSoftenedColor(primaryColor),
      accentColor: accentColor,
      accentColorSoft: getSoftenedColor(accentColor),
    );
  }
}
