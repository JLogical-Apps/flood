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
import 'package:jlogical_utils/src/style/widgets/input/styled_date_field.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_dropdown.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_radio.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_divider.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_tabbed_page.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_error_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
    return HookBuilder(
      builder: (context) {
        final refreshController = useMemoized(() => RefreshController(initialRefresh: false));
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            title: styledPage.titleText.mapIfNonNull((titleText) => StyledContentHeaderText(
                      titleText,
                      textOverrides: StyledTextOverrides(
                        fontWeight: FontWeight.bold,
                      ),
                    )) ??
                styledPage.title,
            foregroundColor: styleContext.emphasisColor,
            iconTheme: IconThemeData(color: styleContext.emphasisColor),
            actions: [
              if (styledPage.actions.isNotEmpty)
                actionButton(
                  context,
                  styleContext: styleContext,
                  actions: styledPage.actions,
                  color: styleContext.emphasisColor,
                ),
            ],
          ),
          body: StyleContextProvider(
            styleContext: styleContextFromBackground(backgroundColor),
            child: SmartRefresher(
              controller: refreshController,
              header: WaterDropMaterialHeader(
                color: styleContext.emphasisColor,
                backgroundColor: styleContext.backgroundColorSoft,
              ),
              enablePullDown: styledPage.onRefresh != null,
              onRefresh: styledPage.onRefresh != null
                  ? () async {
                      await styledPage.onRefresh!();
                      refreshController.refreshCompleted();
                    }
                  : null,
              child: styledPage.body,
            ),
          ),
        );
      },
    );
  }

  Widget tabbedPage(
    BuildContext context,
    StyleContext styleContext,
    StyledTabbedPage tabbedPage,
  ) {
    return HookBuilder(builder: (_) {
      final pageController = usePageController();
      final pageIndex = useState(0);
      final page = tabbedPage.pages[pageIndex.value];

      final backgroundColor = tabbedPage.backgroundColor ?? page.backgroundColor ?? styleContext.backgroundColor;
      final title = tabbedPage.title ?? page.title;
      final actions = tabbedPage.actions ?? page.actions ?? [];

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: StyledContentHeaderText(
            title,
            textOverrides: StyledTextOverrides(
              fontWeight: FontWeight.bold,
            ),
          ),
          foregroundColor: styleContext.emphasisColor,
          iconTheme: IconThemeData(color: styleContext.emphasisColor),
          actions: [
            if (actions.isNotEmpty)
              actionButton(
                context,
                styleContext: styleContext,
                actions: actions,
                color: styleContext.emphasisColor,
              ),
          ],
        ),
        body: PageView(
          controller: pageController,
          scrollBehavior: CupertinoScrollBehavior(),
          onPageChanged: (_page) => pageIndex.value = _page,
          children: tabbedPage.pages.map((page) => page.body).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: styleContext.backgroundColorSoft,
          currentIndex: pageIndex.value,
          onTap: (index) => pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          ),
          items: tabbedPage.pages
              .map((page) => BottomNavigationBarItem(
                    icon: page.icon ?? Container(),
                    backgroundColor: styleContext.backgroundColorSoft,
                    label: page.title,
                  ))
              .toList(),
          selectedLabelStyle: GoogleFonts.getFont(subtitleFontFamily),
          unselectedLabelStyle: GoogleFonts.getFont(subtitleFontFamily),
          selectedItemColor: styleContextFromBackground(backgroundColor).emphasisColor,
          unselectedItemColor: styleContextFromBackground(backgroundColor).foregroundColorSoft,
        ),
      );
    });
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
                                        child: Center(child: section.body),
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
                        onTapped:
                            page.value < onboardingPage.sections.length - 1 ? () => onboardingPage.onSkip!() : null,
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
                            onTapped: onboardingPage.onComplete,
                          )
                        : StyledButton.low(
                            key: ValueKey('next'),
                            text: 'Next',
                            onTapped: () => pageController.animateToPage(
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

  /// A text that uses the values provided unless overridden by the [styledText]'s [StyledTextOverride].
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
          decoration: styledText.decorationOverride ?? TextDecoration.none,
        ),
        overflow: styledText.overflowOverride ?? TextOverflow.clip,
        maxLines: styledText.maxLinesOverride,
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
      fontSize: 38,
      textAlign: TextAlign.center,
      letterSpacing: 2.5,
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
      padding: const EdgeInsets.all(4),
      fontColor: styleContext.emphasisColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget contentSubtitleText(
      BuildContext context, StyleContext styleContext, StyledContentSubtitleText contentSubtitleText) {
    return rawStyledText(
      styledText: contentSubtitleText,
      fontFamily: bodyFontFamily,
      padding: const EdgeInsets.all(4),
      fontColor: styleContext.foregroundColorSoft,
      fontSize: 14,
    );
  }

  @override
  Widget bodyText(BuildContext context, StyleContext styleContext, StyledBodyText bodyText) {
    return rawStyledText(
      styledText: bodyText,
      fontFamily: bodyFontFamily,
      padding: const EdgeInsets.all(4),
      fontColor: styleContext.foregroundColor,
      fontSize: 14,
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
      padding: const EdgeInsets.all(4),
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

        final child = button.text.mapIfNonNull((text) => StyledButtonText(
                  text,
                  textOverrides: StyledTextOverrides(fontColor: newStyleContext.emphasisColor),
                )) ??
            button.child;

        final leading = button.icon.mapIfNonNull((icon) => StyledIcon.medium(button.icon!)) ?? button.leading;

        return StyleContextProvider(
          styleContext: newStyleContext,
          child: leading == null
              ? ElevatedButton(
                  child: child,
                  onPressed: button.onTapped,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(backgroundColor),
                    overlayColor: MaterialStateProperty.all(softenColor(backgroundColor).withOpacity(0.8)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: button.onTapped,
                  icon: leading,
                  label: child ?? Container(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.emphasisColor),
                    overlayColor: MaterialStateProperty.all(
                        softenColor(button.color ?? styleContext.emphasisColor).withOpacity(0.8)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                  ),
                ),
        );
      },
      medium: () {
        final child = button.text.mapIfNonNull((text) => StyledButtonText(text)) ?? button.child;
        final leading = button.icon.mapIfNonNull((icon) => StyledIcon.medium(button.icon!)) ?? button.leading;

        return StyleContextProvider(
          styleContext: styleContextFromBackground(backgroundColor),
          child: leading == null
              ? ElevatedButton(
                  child: child,
                  onPressed: button.onTapped,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.backgroundColorSoft),
                    overlayColor: MaterialStateProperty.all(
                        softenColor(button.color ?? styleContext.backgroundColorSoft).withOpacity(0.8)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: button.onTapped,
                  icon: leading,
                  label: child ?? Container(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.backgroundColorSoft),
                    overlayColor: MaterialStateProperty.all(
                        softenColor(button.color ?? styleContext.backgroundColorSoft).withOpacity(0.8)),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                  ),
                ),
        );
      },
      low: () {
        final child = button.text.mapIfNonNull((text) => StyledButtonText(
                  text,
                  textOverrides: StyledTextOverrides(fontColor: button.color ?? styleContext.emphasisColor),
                )) ??
            button.child;

        final leading = button.icon.mapIfNonNull((icon) => StyledIcon.medium(
                  button.icon!,
                  colorOverride: button.color ?? styleContext.emphasisColor,
                )) ??
            button.leading;

        return leading == null
            ? TextButton(
                child: child ?? Container(),
                onPressed: button.onTapped,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(
                      softenColor(button.color ?? styleContext.emphasisColor).withOpacity(0.3)),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                ),
              )
            : TextButton.icon(
                onPressed: button.onTapped,
                icon: leading,
                label: child ?? Container(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(
                      softenColor(button.color ?? styleContext.emphasisColor).withOpacity(0.3)),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
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
            readOnly: !textField.enabled,
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
            maxLines: textField.maxLines,
            keyboardType: textField.keyboardType,
          ),
        ],
      ),
    );
  }

  @override
  Widget dropdown<T>(BuildContext context, StyleContext styleContext, StyledDropdown<T> dropdown) {
    final _builder = dropdown.builder ??
        (item) => StyledBodyText(
              item?.toString() ?? 'None',
              textOverrides: StyledTextOverrides(padding: EdgeInsets.zero),
            );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dropdown.label != null)
            StyledContentSubtitleText(
              dropdown.label!,
            ),
          DropdownButtonFormField<T?>(
            isExpanded: true,
            value: dropdown.value,
            dropdownColor: softenColor(styleContext.backgroundColorSoft),
            hint: StyledBodyText(
              'Select an option',
              textOverrides: StyledTextOverrides(
                fontColor: styleContext.emphasisColor,
                padding: EdgeInsets.zero,
                fontStyle: FontStyle.italic,
              ),
            ),
            icon: StyledIcon(
              Icons.arrow_drop_down,
              paddingOverride: EdgeInsets.zero,
            ),
            style: GoogleFonts.getFont(bodyFontFamily).copyWith(color: styleContext.foregroundColor),
            decoration: InputDecoration(
              errorText: dropdown.errorText,
              filled: true,
              fillColor: styleContext.backgroundColorSoft,
              focusedBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: styleContext.foregroundColor,
                    width: 0.5,
                  )),
            ),
            items: [
              if (dropdown.canBeNone) null,
              ...dropdown.options,
            ]
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: StyleProvider(
                        style: this,
                        child: _builder(value),
                      ),
                    ))
                .toList(),
            onChanged: dropdown.onChanged != null
                ? (value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    dropdown.onChanged!(value);
                  }
                : null,
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

  Widget radio<T>(BuildContext context, StyleContext styleContext, StyledRadio<T> radio) {
    return GestureDetector(
      onTap: radio.onChanged != null ? () => radio.onChanged!(radio.radioValue) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (radio.label != null)
                StyledContentSubtitleText(
                  radio.label!,
                  textOverrides: StyledTextOverrides(padding: EdgeInsets.zero),
                ),
              Radio<T>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: radio.radioValue,
                groupValue: radio.groupValue,
                onChanged: radio.onChanged != null ? (value) => radio.onChanged!(value as T) : null,
                fillColor: radio.hasError
                    ? MaterialStateProperty.all(Colors.red)
                    : MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.selected)
                        ? styleContext.emphasisColor
                        : styleContext.foregroundColor),
              ),
            ],
          ),
          if (radio.hasError) StyledErrorText(radio.errorText!),
        ],
      ),
    );
  }

  Widget dateField(BuildContext context, StyleContext styleContext, StyledDateField dateField) {
    final initialDate = dateField.date ?? DateTime.now();
    return StyledTextField(
      key: ObjectKey(initialDate),
      label: dateField.label,
      errorText: dateField.errorText,
      leading: dateField.leading ?? StyledIcon(Icons.calendar_today),
      initialText: initialDate.formatDate(isLong: false),
      enabled: false,
      onTap: dateField.onChanged != null
          ? () async {
              final result = await showDatePicker(
                context: context,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: primaryColor,
                        onPrimary: styleContextFromBackground(primaryColor).foregroundColor,
                        surface: primaryColor,
                        onSurface: initialStyleContext.foregroundColor,
                      ),
                      dialogTheme: DialogTheme(
                        backgroundColor: backgroundColorSoft,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: child ?? Container(),
                  );
                },
                initialDate: initialDate,
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now().add(
                  Duration(days: 1000),
                ),
              );

              FocusScope.of(context).requestFocus(FocusNode());

              if (result != null) dateField.onChanged!(result);
            }
          : null,
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

    final newStyleContext = content.emphasisColorOverride == null
        ? styleContextFromBackground(backgroundColor)
        : styleContextFromBackground(backgroundColor).copyWith(
            emphasisColor: content.emphasisColorOverride,
          );

    final header = content.headerText != null ? StyledContentHeaderText(content.headerText!) : content.header;
    final body = content.bodyText != null ? StyledContentSubtitleText(content.bodyText!) : content.body;

    return ClickableCard(
      color: backgroundColor,
      borderRadius: content.borderRadius,
      splashColor: softenColor(backgroundColor).withOpacity(0.8),
      onTap: content.onTapped,
      child: StyleContextProvider(
        styleContext: newStyleContext,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: header != null ? header : body,
              subtitle: header != null ? body : null,
              leading: content.leading,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (content.trailing != null) content.trailing!,
                  if (content.actions.isNotEmpty)
                    actionButton(
                      context,
                      styleContext: styleContext,
                      actions: content.actions,
                    ),
                ],
              ),
            ),
            ...content.children,
          ],
        ),
      ),
    );
  }

  @override
  Widget category(BuildContext context, StyleContext styleContext, StyledCategory category) {
    StyleContext styleContextWithEmphasisOverride(StyleContext styleContext) {
      if (category.emphasisColorOverride == null) return styleContext;
      return styleContext.copyWith(
        emphasisColor: category.emphasisColorOverride!,
      );
    }

    final emphasisColor = category.emphasisColorOverride ?? styleContext.emphasisColor;

    final header = category.headerText != null ? StyledContentHeaderText(category.headerText!) : category.header;
    final body = category.bodyText != null ? StyledContentSubtitleText(category.bodyText!) : category.body;

    return category.emphasis.map(
      high: () {
        return ClickableCard(
          color: emphasisColor,
          borderRadius: category.borderRadius,
          onTap: category.onTapped,
          child: StyleContextProvider(
            styleContext: styleContextWithEmphasisOverride(styleContextFromBackground(styleContext.emphasisColor)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null || body != null || category.leading != null || category.trailing != null)
                  ListTile(
                    title: header != null ? header : body,
                    subtitle: header != null ? body : null,
                    leading: category.leading,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category.trailing != null) category.trailing!,
                        if (category.actions.isNotEmpty)
                          actionButton(
                            context,
                            styleContext: styleContext,
                            actions: category.actions,
                          ),
                      ],
                    ),
                  ),
                ...category.children
              ],
            ),
          ),
        );
      },
      medium: () {
        return ClickableCard(
          color: styleContext.backgroundColorSoft,
          borderRadius: category.borderRadius,
          onTap: category.onTapped,
          child: StyleContextProvider(
            styleContext:
                styleContextWithEmphasisOverride(styleContextFromBackground(styleContext.backgroundColorSoft)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null || body != null || category.leading != null || category.trailing != null)
                  ListTile(
                    title: header != null ? header : body,
                    subtitle: header != null ? body : null,
                    leading: category.leading,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (category.trailing != null) category.trailing!,
                        if (category.actions.isNotEmpty)
                          actionButton(
                            context,
                            styleContext: styleContext,
                            actions: category.actions,
                          ),
                      ],
                    ),
                  ),
                ...category.children
              ],
            ),
          ),
        );
      },
      low: () {
        return StyleContextProvider(
          styleContext: styleContextWithEmphasisOverride(styleContext),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (header != null || body != null || category.leading != null || category.trailing != null)
                ListTile(
                  title: header != null ? header : body,
                  subtitle: header != null ? body : null,
                  leading: category.leading,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (category.trailing != null) category.trailing!,
                      if (category.actions.isNotEmpty)
                        actionButton(
                          context,
                          styleContext: styleContext,
                          actions: category.actions,
                        ),
                    ],
                  ),
                ),
              ...category.children
            ],
          ),
        );
      },
    );
  }

  @override
  Widget icon(BuildContext context, StyleContext styleContext, StyledIcon icon) {
    final color = icon.colorOverride ??
        icon.emphasis.map(
          high: () => styleContext.emphasisColor,
          medium: () => styleContext.foregroundColor,
          low: () => styleContext.backgroundColorSoft,
        );
    return Padding(
      padding: icon.paddingOverride ?? const EdgeInsets.all(4.0),
      child: Icon(
        icon.iconData,
        color: color,
        size: icon.size,
      ),
    );
  }

  @override
  Widget chip(BuildContext context, StyleContext styleContext, StyledChip chip) {
    final backgroundColor = chip.color ??
        chip.emphasis.map<Color>(
          high: () => styleContext.emphasisColor,
          medium: () => styleContext.backgroundColorSoft,
          low: () => styleContext.backgroundColorSoft,
        );

    final newStyleContext = styleContextFromBackground(backgroundColor);

    final foregroundColor = chip.emphasis.map<Color>(
      high: () => newStyleContext.emphasisColor,
      medium: () => newStyleContext.emphasisColor,
      low: () => newStyleContext.foregroundColor,
    );

    return Padding(
      padding: chip.paddingOverride ?? EdgeInsets.all(4),
      child: StyleContextProvider(
        styleContext: newStyleContext,
        child: chip.onTapped == null
            ? Chip(
                backgroundColor: backgroundColor,
                label: StyledButtonText(
                  chip.text,
                  textOverrides: StyledTextOverrides(
                    fontColor: foregroundColor,
                    padding: EdgeInsets.zero,
                  ),
                ),
                avatar: chip.icon != null
                    ? StyledIcon.medium(
                        chip.icon!,
                        colorOverride: foregroundColor,
                        paddingOverride: EdgeInsets.zero,
                      )
                    : null,
              )
            : ActionChip(
                backgroundColor: backgroundColor,
                label: StyledButtonText(
                  chip.text,
                  textOverrides: StyledTextOverrides(
                    fontColor: foregroundColor,
                    padding: EdgeInsets.zero,
                  ),
                ),
                avatar: chip.icon != null
                    ? StyledIcon.medium(
                        chip.icon!,
                        colorOverride: foregroundColor,
                        paddingOverride: EdgeInsets.zero,
                      )
                    : null,
                onPressed: chip.onTapped!,
              ),
      ),
    );
  }

  @override
  Widget divider(BuildContext context, StyleContext styleContext, StyledDivider divider) {
    return Divider(
      color: styleContext.backgroundColorSoft.withOpacity(0.4),
    );
  }

  @override
  Future<T> showDialog<T>({required BuildContext context, required StyledDialog dialog}) async {
    final styleContext = initialStyleContext;
    return await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StyleProvider(
          style: this,
          child: ScrollColumn(
            children: [
              Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: styleContext.backgroundColorSoft,
                  ),
                  child: StyleContextProvider(
                    styleContext: styleContextFromBackground(styleContext.backgroundColorSoft),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: StyledCategory(
                        headerText: dialog.titleText,
                        children: [dialog.body],
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

  @override
  Future<T?> navigateTo<T>({required BuildContext context, required Widget Function() page}) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (_) => page()));
  }

  @override
  void navigateBack<T>({required BuildContext context, T? result}) {
    Navigator.of(context).pop(result);
  }

  @override
  void navigateReplacement({required BuildContext context, required Widget Function() newPage}) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => newPage()));
  }

  Widget actionButton(
    BuildContext context, {
    required StyleContext styleContext,
    required List<ActionItem> actions,
    Color? color,
  }) {
    return IconButton(
      icon: StyledIcon(
        Icons.more_vert,
        colorOverride: color,
        paddingOverride: EdgeInsets.zero,
      ),
      onPressed: () {
        showDialog(
          context: context,
          dialog: StyledDialog(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: actions
                      .map<Widget>((action) => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: styleContext.backgroundColorSoft,
                              onTap: () {
                                Navigator.of(context).pop();
                                action.onPerform?.call();
                              },
                              child: ListTile(
                                title: StyledContentSubtitleText(
                                  action.name,
                                  textOverrides: StyledTextOverrides(fontColor: action.color),
                                ),
                                subtitle: action.description != null ? StyledBodyText(action.description!) : null,
                                leading: action.icon != null
                                    ? StyledIcon(action.icon!, colorOverride: action.color)
                                    : action.leading,
                              ),
                            ),
                          ))
                      .toList() +
                  [SafeArea(child: Container())],
            ),
          ),
        );
      },
    );
  }

  /// Animates the opacity of [child] whenever [isVisible] changes.
  Widget animatedFadeIn({required bool isVisible, required Widget child}) => AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 400),
        child: child,
      );

  /// Generates a [StyleContext] from the [backgroundColor].
  StyleContext styleContextFromBackground(Color backgroundColor) {
    final isBackgroundVariant = _isBackgroundVariant(backgroundColor);
    final isNeutralBackground = _isNeutralColor(backgroundColor);

    final foregroundColor = backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
    final emphasisColor = (isBackgroundVariant || isNeutralBackground) ? primaryColor : foregroundColor;

    return StyleContext(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      emphasisColor: emphasisColor,
      getSoftened: (color) => softenColor(color),
    );
  }

  /// Whether the [color] is derived from [backgroundColor].
  bool _isBackgroundVariant(Color color) {
    return color == backgroundColor || color == backgroundColorSoft || color == softenColor(backgroundColorSoft);
  }

  /// Whether the [color] is a neutral color.
  bool _isNeutralColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance < 0.05 || luminance > 0.95;
  }

  /// Softens colors by making light colors darker and dark colors lighter.
  static Color softenColor(Color color) {
    return color.computeLuminance() < 0.5 ? color.lighten() : color.darken(5);
  }
}
