import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_category.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_button.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_checkbox.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_divider.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_error_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../style_context_provider.dart';

class FlatStyle extends Style {
  final Color primaryColor;

  Color get primaryColorSoft => softenColor(primaryColor);

  final Color backgroundColor;

  Color get backgroundColorSoft => softenColor(backgroundColor);

  final String titleFontFamily;
  final String subtitleFontFamily;
  final String bodyFontFamily;

  FlatStyle({
    this.primaryColor: Colors.blue,
    this.backgroundColor: Colors.white,
    this.titleFontFamily: 'Montserrat',
    this.subtitleFontFamily: 'Quicksand',
    this.bodyFontFamily: 'Lato',
  });

  @override
  StyleContext get initialStyleContext => styleContextFromBackground(backgroundColor);

  @override
  Widget page(BuildContext context, StyleContext styleContext, StyledPage styledPage) {
    final backgroundColor = styledPage.backgroundColor ?? styleContext.backgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: styledPage.title != null ? StyledContentHeaderText(styledPage.title!) : null,
        foregroundColor: styleContext.emphasisColor,
        iconTheme: IconThemeData(color: styleContext.emphasisColor),
        actions: [
          if (styledPage.actions.isNotEmpty)
            actionButton(
              context,
              actions: styledPage.actions,
              color: styleContext.emphasisColor,
            ),
        ],
      ),
      body: StyleContextProvider(
        styleContext: styleContextFromBackground(backgroundColor),
        child: styledPage.body,
      ),
    );
  }

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
          fontStyle: styledText.fontStyleOverride ?? fontStyle,
          letterSpacing: styledText.letterSpacingOverride ?? letterSpacing,
        ),
      ),
    );
  }

  @override
  Widget titleText(BuildContext context, StyleContext styleContext, StyledTitleText titleText) {
    return rawStyledText(
      styledText: titleText,
      text: titleText.text.toUpperCase(),
      fontFamily: titleFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.emphasisColor,
      fontSize: 48,
      textAlign: TextAlign.center,
      letterSpacing: 3,
    );
  }

  @override
  Widget subtitleText(BuildContext context, StyleContext styleContext, StyledSubtitleText subtitleText) {
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
  Widget contentHeaderText(BuildContext context, StyleContext styleContext, StyledContentHeaderText contentHeaderText) {
    return rawStyledText(
      styledText: contentHeaderText,
      fontFamily: subtitleFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.emphasisColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget contentSubtitleText(
      BuildContext context, StyleContext styleContext, StyledContentSubtitleText contentSubtitleText) {
    return rawStyledText(
      styledText: contentSubtitleText,
      fontFamily: bodyFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.foregroundColorSoft,
      fontSize: 16,
    );
  }

  @override
  Widget bodyText(BuildContext context, StyleContext styleContext, StyledBodyText bodyText) {
    return rawStyledText(
      styledText: bodyText,
      fontFamily: bodyFontFamily,
      padding: const EdgeInsets.all(8),
      fontColor: styleContext.foregroundColor,
      fontSize: 18,
    );
  }

  @override
  Widget buttonText(BuildContext context, StyleContext styleContext, StyledButtonText buttonText) {
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
  Widget button(BuildContext context, StyleContext styleContext, StyledButton button) {
    return button.emphasis.map(
      high: () {
        final backgroundColor = button.color ?? styleContext.emphasisColor;
        final newStyleContext = styleContextFromBackground(backgroundColor);
        return StyleContextProvider(
          styleContext: newStyleContext,
          child: button.icon == null
              ? ElevatedButton(
                  child: StyledButtonText(
                    button.text,
                    textOverrides: StyledTextOverrides(
                      fontColor: newStyleContext.emphasisColor,
                    ),
                  ),
                  onPressed: button.onTap,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(backgroundColor),
                    overlayColor: MaterialStateProperty.all(softenColor(backgroundColor).withOpacity(0.8)),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: button.onTap,
                  icon: StyledIcon.medium(button.icon!),
                  label: StyledButtonText(button.text),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.emphasisColor),
                    overlayColor: MaterialStateProperty.all(
                        softenColor(button.color ?? styleContext.emphasisColor).withOpacity(0.8)),
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
                    overlayColor: MaterialStateProperty.all(
                        softenColor(button.color ?? styleContext.backgroundColorSoft).withOpacity(0.8)),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: button.onTap,
                  icon: StyledIcon.medium(button.icon!),
                  label: StyledButtonText(button.text),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.backgroundColorSoft),
                    overlayColor: MaterialStateProperty.all(
                        softenColor(button.color ?? styleContext.backgroundColorSoft).withOpacity(0.8)),
                  ),
                ),
        );
      },
      low: () {
        return button.icon == null
            ? TextButton(
                child: StyledButtonText(
                  button.text,
                  textOverrides: StyledTextOverrides(fontColor: button.color ?? styleContext.emphasisColor),
                ),
                onPressed: button.onTap,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(
                      softenColor(button.color ?? styleContext.emphasisColor).withOpacity(0.3)),
                ),
              )
            : TextButton.icon(
                onPressed: button.onTap,
                icon: StyledIcon.medium(button.icon!, color: button.color ?? styleContext.emphasisColor),
                label: StyledButtonText(
                  button.text,
                  textOverrides: StyledTextOverrides(fontColor: button.color ?? styleContext.emphasisColor),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(
                      softenColor(button.color ?? styleContext.emphasisColor).withOpacity(0.3)),
                ),
              );
      },
    );
  }

  @override
  Widget textField(BuildContext context, StyleContext styleContext, StyledTextField textField) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (textField.label != null) StyledContentSubtitleText(textField.label!),
          TextFormField(
            initialValue: textField.initialText,
            style: GoogleFonts.getFont(bodyFontFamily).copyWith(
              color: styleContext.foregroundColor,
            ),
            obscureText: textField.obscureText,
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
                  color: styleContext.emphasisColor,
                ),
              ),
              hintText: textField.hintText,
              hintStyle: GoogleFonts.getFont(bodyFontFamily).copyWith(
                color: styleContext.emphasisColorSoft,
                fontStyle: FontStyle.italic,
              ),
            ),
            cursorColor: primaryColor,
            onTap: textField.onTap,
            onChanged: textField.onChanged,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }

  @override
  Widget checkbox(BuildContext context, StyleContext styleContext, StyledCheckbox checkbox) {
    final checkColor = checkbox.hasError ? Colors.red : styleContext.emphasisColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (checkbox.label != null)
              GestureDetector(
                child: StyledBodyText(checkbox.label!),
                onTap: checkbox.onChanged != null ? () => checkbox.onChanged!(!checkbox.value) : null,
              ),
            Checkbox(
              value: checkbox.value,
              onChanged: checkbox.onChanged != null ? (value) => checkbox.onChanged!(value ?? false) : null,
              overlayColor: MaterialStateProperty.all(styleContext.foregroundColor.withOpacity(0.2)),
              fillColor: MaterialStateProperty.all(checkColor),
              checkColor: checkbox.hasError
                  ? styleContextFromBackground(checkColor).foregroundColor
                  : styleContextFromBackground(checkColor).emphasisColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
              side: BorderSide(
                color: checkbox.hasError ? Colors.red : styleContext.emphasisColorSoft,
                width: 2,
              ),
            ),
          ],
        ),
        if (checkbox.errorText != null) StyledErrorText(checkbox.errorText!),
      ],
    );
  }

  @override
  Widget content(BuildContext context, StyleContext styleContext, StyledContent content) {
    // Flat Style treats low and medium emphasis contents as the same.
    final backgroundColor = content.emphasis.map(
      low: () => styleContext.backgroundColorSoft,
      medium: () => styleContext.backgroundColorSoft,
      high: () => styleContext.emphasisColor,
    );

    return ClickableCard(
      color: backgroundColor,
      splashColor: softenColor(backgroundColor).withOpacity(0.8),
      onTap: content.onTap,
      child: StyleContextProvider(
        styleContext: styleContextFromBackground(backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: content.header != null
                  ? StyledContentHeaderText(content.header!)
                  : (content.content != null ? StyledContentSubtitleText(content.content!) : null),
              subtitle: (content.header != null && content.content != null)
                  ? StyledContentSubtitleText(content.content!)
                  : null,
              leading: content.lead,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (content.trailing != null) content.trailing!,
                  if (content.actions.isNotEmpty) actionButton(context, actions: content.actions),
                ],
              ),
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
  Widget contentGroup(BuildContext context, StyleContext styleContext, StyledCategory contentGroup) {
    return contentGroup.emphasis.map(
      high: () {
        return ClickableCard(
          color: styleContext.emphasisColor,
          onTap: contentGroup.onTap,
          child: StyleContextProvider(
            styleContext: styleContextFromBackground(styleContext.emphasisColor),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (contentGroup.header != null ||
                    contentGroup.content != null ||
                    contentGroup.lead != null ||
                    contentGroup.trailing != null)
                  ListTile(
                    title: contentGroup.header != null
                        ? StyledContentHeaderText(contentGroup.header!)
                        : (contentGroup.content != null ? StyledContentSubtitleText(contentGroup.content!) : null),
                    subtitle: (contentGroup.header != null && contentGroup.content != null)
                        ? StyledContentSubtitleText(contentGroup.content!)
                        : null,
                    leading: contentGroup.lead,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (contentGroup.trailing != null) contentGroup.trailing!,
                        if (contentGroup.actions.isNotEmpty) actionButton(context, actions: contentGroup.actions),
                      ],
                    ),
                  ),
                ...contentGroup.children
              ],
            ),
          ),
        );
      },
      medium: () {
        return ClickableCard(
          color: styleContext.backgroundColorSoft,
          onTap: contentGroup.onTap,
          child: StyleContextProvider(
            styleContext: styleContextFromBackground(styleContext.backgroundColorSoft),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (contentGroup.header != null ||
                    contentGroup.content != null ||
                    contentGroup.lead != null ||
                    contentGroup.trailing != null)
                  ListTile(
                    title: contentGroup.header != null
                        ? StyledContentHeaderText(contentGroup.header!)
                        : (contentGroup.content != null ? StyledContentHeaderText(contentGroup.content!) : null),
                    subtitle: (contentGroup.header != null && contentGroup.content != null)
                        ? StyledContentSubtitleText(contentGroup.content!)
                        : null,
                    leading: contentGroup.lead,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (contentGroup.trailing != null) contentGroup.trailing!,
                        if (contentGroup.actions.isNotEmpty) actionButton(context, actions: contentGroup.actions),
                      ],
                    ),
                  ),
                ...contentGroup.children
              ],
            ),
          ),
        );
      },
      low: () {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (contentGroup.header != null ||
                contentGroup.content != null ||
                contentGroup.lead != null ||
                contentGroup.trailing != null)
              ListTile(
                title: contentGroup.header != null
                    ? StyledContentHeaderText(contentGroup.header!)
                    : (contentGroup.content != null ? StyledContentHeaderText(contentGroup.content!) : null),
                subtitle: (contentGroup.header != null && contentGroup.content != null)
                    ? StyledContentSubtitleText(contentGroup.content!)
                    : null,
                leading: contentGroup.lead,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (contentGroup.trailing != null) contentGroup.trailing!,
                    if (contentGroup.actions.isNotEmpty) actionButton(context, actions: contentGroup.actions),
                  ],
                ),
              ),
            ...contentGroup.children
          ],
        );
      },
    );
  }

  @override
  Widget icon(BuildContext context, StyleContext styleContext, StyledIcon icon) {
    final color = icon.color ??
        icon.emphasis.map(
          high: () => styleContext.emphasisColor,
          medium: () => styleContext.foregroundColor,
          low: () => styleContext.backgroundColorSoft,
        );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon.iconData,
        color: color,
        size: icon.size,
      ),
    );
  }

  @override
  Widget divider(BuildContext context, StyleContext styleContext, StyledDivider divider) {
    return Divider(
      color: styleContext.backgroundColorSoft.withOpacity(0.4),
    );
  }

  Widget actionButton(BuildContext context, {required List<ActionItem> actions, Color? color}) {
    return MenuButton(
        child: StyledIcon.medium(Icons.more_vert, color: color),
        foregroundColor: styleContextFromBackground(softenColor(backgroundColorSoft)).foregroundColor,
        backgroundColor: softenColor(backgroundColorSoft),
        elevation: 10,
        fontFamily: subtitleFontFamily,
        items: actions
            .map((action) => MenuItem(
                  text: action.name,
                  description: action.description,
                  color: action.color ?? primaryColor,
                  icon: action.icon,
                  onPressed: action.onPerform ?? () {},
                ))
            .toList());
  }

  Widget animatedFadeIn({required bool isVisible, required Widget child}) => AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 400),
        child: child,
      );

  static Color softenColor(Color color) {
    return color.computeLuminance() < 0.5 ? color.lighten() : color.darken(5);
  }

  StyleContext styleContextFromBackground(Color backgroundColor) {
    final isPrimaryBackground = _isPrimaryColor(backgroundColor);

    final foregroundColor = backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    final emphasisColor = !isPrimaryBackground ? primaryColor : foregroundColor;

    return StyleContext(
      backgroundColor: backgroundColor,
      backgroundColorSoft: softenColor(backgroundColor),
      foregroundColor: foregroundColor,
      foregroundColorSoft: softenColor(foregroundColor),
      emphasisColor: emphasisColor,
      emphasisColorSoft: softenColor(emphasisColor),
    );
  }

  bool _isPrimaryColor(Color color) {
    return color == primaryColor || color == primaryColorSoft || color == softenColor(primaryColorSoft);
  }
}
