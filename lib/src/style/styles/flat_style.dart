import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/style/emphasis.dart';
import 'package:jlogical_utils/src/style/style.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_category.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_content.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_button.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_checkbox.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_date_field.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_dropdown.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_menu_button.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_radio.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_divider.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_tabbed_page.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_content_header_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_error_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_span.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_style.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../widgets/export.dart';
import '../style_context.dart';
import '../style_context_provider.dart';
import '../style_provider.dart';
import '../widgets/carousel/styled_carousel.dart';
import '../widgets/content/styled_container.dart';
import '../widgets/input/action_item.dart';
import '../widgets/input/styled_color_picker.dart';
import '../widgets/input/styled_icon_button.dart';
import '../widgets/misc/styled_calendar.dart';
import '../widgets/misc/styled_chip.dart';
import '../widgets/misc/styled_loading_indicator.dart';
import '../widgets/misc/styled_message.dart';
import '../widgets/pages/styled_dialog.dart';
import '../widgets/pages/styled_onboarding_page.dart';
import '../widgets/pages/styled_page.dart';
import '../widgets/text/styled_body_text.dart';
import '../widgets/text/styled_button_text.dart';
import '../widgets/text/styled_content_subtitle_text.dart';
import '../widgets/text/styled_text_overrides.dart';
import '../widgets/text/styled_title_text.dart';

class FlatStyle extends Style {
  final Color primaryColor;
  final Color accentColor;

  Color get primaryColorSoft => softenColor(primaryColor);

  final Color backgroundColor;

  Color get backgroundColorSoft => softenColor(backgroundColor);

  FlatStyle({
    this.primaryColor: Colors.blue,
    this.accentColor: Colors.purple,
    this.backgroundColor: Colors.white,
  });

  @override
  StyleContext get initialStyleContext => styleContextFromBackground(backgroundColor);

  @override
  Widget page(BuildContext context, StyleContext styleContext, StyledPage styledPage) {
    final backgroundColor = styledPage.backgroundColor ?? styleContext.backgroundColor;
    final appBarTitle = styledPage.titleText.mapIfNonNull((titleText) => StyledContentHeaderText(
              titleText,
              textOverrides: StyledTextOverrides(fontWeight: FontWeight.bold),
            )) ??
        styledPage.title;

    final shouldShowAppBar = appBarTitle != null ||
        styledPage.actions.isNotEmpty ||
        styledPage.actionBarWidgets.isNotEmpty ||
        Navigator.of(context).canPop();
    return HookBuilder(
      builder: (context) {
        final refreshController = useMemoized(() => RefreshController(initialRefresh: false));
        return LoadingOverlay(
          isLoading: styledPage.isLoading,
          progressIndicator: StyledLoadingIndicator(color: initialStyleContext.emphasisColor),
          color: initialStyleContext.emphasisColorSoft,
          opacity: 0.2,
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: shouldShowAppBar
                ? _styledAppBar(
                    context,
                    title: appBarTitle,
                    actions: styledPage.actions,
                    actionBarWidgets: styledPage.actionBarWidgets,
                  )
                : null,
            body: StyleContextProvider(
              styleContext: styleContextFromBackground(backgroundColor),
              child: styledPage.onRefresh == null
                  ? styledPage.body
                  : SmartRefresher(
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
          ),
        );
      },
    );
  }

  AppBar _styledAppBar(
    BuildContext context, {
    Widget? title,
    List<ActionItem> actions: const [],
    List<Widget> actionBarWidgets: const [],
  }) {
    final styleContext = context.styleContext();

    final highActions = actions.where((action) => action.emphasis == Emphasis.high).toList();
    final lowMediumActions = actions.where((action) => action.emphasis != Emphasis.high).toList();

    return AppBar(
      backgroundColor: styleContext.backgroundColor,
      title: title,
      elevation: 0,
      centerTitle: true,
      foregroundColor: styleContext.emphasisColor,
      iconTheme: IconThemeData(color: styleContext.emphasisColor),
      actions: [
        ...actionBarWidgets,
        ...highActions.map((action) => Tooltip(
              message: action.name,
              child: StyledIconButton(
                icon: action.icon ?? Icons.circle,
                onTapped: action.onPerform,
                color: action.color,
              ),
            )),
        if (lowMediumActions.isNotEmpty)
          Builder(
            builder: (context) {
              return actionButton(
                context,
                actions: lowMediumActions,
                color: styleContext.emphasisColor,
              );
            },
          ),
      ],
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
      final tabColor = tabbedPage.tabsColor ?? styleContext.backgroundColorSoft;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: _styledAppBar(
          context,
          title: StyledContentHeaderText(
            title,
            textOverrides: StyledTextOverrides(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: actions,
        ),
        body: PageView(
          controller: pageController,
          scrollBehavior: CupertinoScrollBehavior(),
          onPageChanged: (_page) => pageIndex.value = _page,
          children: tabbedPage.pages.map((page) => page.body).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: tabColor,
          elevation: 0,
          currentIndex: pageIndex.value,
          onTap: (index) => pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          ),
          items: tabbedPage.pages
              .map((page) => BottomNavigationBarItem(
                    icon: page.icon ?? Container(),
                    backgroundColor: tabColor,
                    label: page.title,
                  ))
              .toList(),
          selectedLabelStyle: toTextStyle(styledTextStyle: bodyTextStyle(styleContext)),
          unselectedLabelStyle: toTextStyle(styledTextStyle: bodyTextStyle(styleContext)),
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
    return StyledPage(
      body: StyledCarousel(
        children: onboardingPage.sections
            .map((section) => SafeArea(
                  child: Column(
                    children: [
                      StyleContextProvider(
                        styleContext: styleContextFromBackground(backgroundColor),
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
                        height: 40,
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

  @override
  StyledTextStyle titleTextStyle(StyleContext styleContext) => StyledTextStyle(
        fontFamily: 'Montserrat',
        fontColor: styleContext.emphasisColor,
        fontSize: 38,
        textAlign: TextAlign.center,
        letterSpacing: 2.5,
        padding: const EdgeInsets.all(8),
        transformer: (text) => text.toUpperCase(),
      );

  @override
  StyledTextStyle subtitleTextStyle(StyleContext styleContext) => StyledTextStyle(
        fontFamily: 'Quicksand',
        fontColor: styleContext.foregroundColor,
        fontSize: 28,
        textAlign: TextAlign.center,
        padding: const EdgeInsets.all(8),
      );

  @override
  StyledTextStyle contentHeaderTextStyle(StyleContext styleContext) => StyledTextStyle(
        fontFamily: 'Quicksand',
        fontColor: styleContext.emphasisColor,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        padding: const EdgeInsets.all(4),
      );

  @override
  StyledTextStyle contentSubtitleTextStyle(StyleContext styleContext) => StyledTextStyle(
        fontFamily: 'Lato',
        fontColor: styleContext.foregroundColorSoft,
        fontSize: 14,
        padding: const EdgeInsets.all(4),
      );

  @override
  StyledTextStyle bodyTextStyle(StyleContext styleContext) => StyledTextStyle(
        fontFamily: 'Lato',
        fontColor: styleContext.foregroundColor,
        fontSize: 14,
        padding: const EdgeInsets.all(4),
      );

  @override
  StyledTextStyle buttonTextStyle(StyleContext styleContext) => StyledTextStyle(
        fontFamily: 'Lato',
        fontColor: styleContext.foregroundColor,
        fontSize: 12,
        padding: const EdgeInsets.all(4),
        fontWeight: FontWeight.w600,
        textAlign: TextAlign.center,
        transformer: (text) => text.toUpperCase(),
      );

  Widget text(BuildContext context, StyleContext styleContext, StyledText text) {
    final textStyle = text.getStyle(this, styleContext);
    return Padding(
      padding: text.paddingOverride ?? textStyle.padding,
      child: Text(
        textStyle.transformer.mapIfNonNull((transformer) => transformer(text.text)) ?? text.text,
        textAlign: text.textAlignOverride ?? textStyle.textAlign,
        style: GoogleFonts.getFont(text.fontFamilyOverride ?? textStyle.fontFamily).copyWith(
          color: text.fontColorOverride ?? textStyle.fontColor,
          fontSize: text.fontSizeOverride ?? textStyle.fontSize,
          fontWeight: text.fontWeightOverride ?? textStyle.fontWeight,
          fontStyle: text.fontStyleOverride ?? textStyle.fontStyle,
          letterSpacing: text.letterSpacingOverride ?? textStyle.letterSpacing,
          decoration: text.decorationOverride ?? TextDecoration.none,
        ),
        overflow: text.overflowOverride ?? TextOverflow.clip,
        maxLines: text.maxLinesOverride,
      ),
    );
  }

  Widget textSpan(BuildContext context, StyleContext styleContext, StyledTextSpan textSpan) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text.rich(
        TextSpan(
            children: textSpan.children
                .map((text) => TextSpan(
                    text: text.text,
                    style: toTextStyle(
                      styledTextStyle: text.getStyle(this, styleContext),
                      overrides: text.overrides,
                    )))
                .toList()),
        textAlign: textSpan.textAlign,
      ),
    );
  }

  /// Converts a [styledTextStyle] to a [TextStyle] with optional overrides from [overrides].
  TextStyle toTextStyle({required StyledTextStyle styledTextStyle, StyledTextOverrides? overrides}) {
    return GoogleFonts.getFont(overrides?.fontFamily ?? styledTextStyle.fontFamily).copyWith(
      color: overrides?.fontColor ?? styledTextStyle.fontColor,
      fontSize: overrides?.fontSize ?? styledTextStyle.fontSize,
      fontWeight: overrides?.fontWeight ?? styledTextStyle.fontWeight,
      fontStyle: overrides?.fontStyle ?? styledTextStyle.fontStyle,
      letterSpacing: overrides?.letterSpacing ?? styledTextStyle.letterSpacing,
    );
  }

  @override
  Widget button(BuildContext context, StyleContext styleContext, StyledButton button) {
    return HookBuilder(
      builder: (context) {
        final isLoading = useState(false);
        final isMounted = useIsMounted();
        final onTapped = button.onTapped.mapIfNonNull((onTapped) => () async {
              if (isLoading.value) return;

              isLoading.value = true;
              await runZonedGuarded(onTapped, (error, stack) {
                if (isMounted()) isLoading.value = false;
                throw error;
              });
              if (isMounted()) isLoading.value = false;
            });

        final isIconButton = button.text == null && button.icon != null;
        if (isIconButton) {
          return IconButton(
            icon: _loadingCrossFade(
              isLoading: isLoading.value,
              child: StyledIcon(
                button.icon!,
                colorOverride: button.color ?? styleContext.emphasisColor,
              ),
            ),
            onPressed: onTapped,
          );
        }

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
                      child: _loadingCrossFade(
                        isLoading: isLoading.value,
                        child: child ?? Container(),
                      ),
                      onPressed: onTapped,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(backgroundColor),
                        overlayColor: MaterialStateProperty.all(softenColor(backgroundColor).withOpacity(0.8)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: onTapped,
                      icon: _loadingCrossFade(
                        isLoading: isLoading.value,
                        child: leading,
                      ),
                      label: child ?? Container(),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(backgroundColor),
                        overlayColor: MaterialStateProperty.all(softenColor(backgroundColor).withOpacity(0.8)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                      ),
                    ),
            );
          },
          medium: () {
            final backgroundColor = button.color ?? styleContext.backgroundColor;

            final child = button.text.mapIfNonNull((text) => StyledButtonText(text)) ?? button.child;
            final leading = button.icon.mapIfNonNull((icon) => StyledIcon.medium(button.icon!)) ?? button.leading;

            final newStyleContext = styleContextFromBackground(backgroundColor);

            return StyleContextProvider(
              styleContext: newStyleContext,
              child: leading == null
                  ? ElevatedButton(
                      child: _loadingCrossFade(
                        loadingIndicatorColor: newStyleContext.foregroundColor,
                        isLoading: isLoading.value,
                        child: child ?? Container(),
                      ),
                      onPressed: onTapped,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(button.color ?? styleContext.backgroundColorSoft),
                        overlayColor: MaterialStateProperty.all(
                            softenColor(button.color ?? styleContext.backgroundColorSoft).withOpacity(0.8)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: onTapped,
                      icon: _loadingCrossFade(
                        loadingIndicatorColor: newStyleContext.foregroundColor,
                        isLoading: isLoading.value,
                        child: leading,
                      ),
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
                    child: _loadingCrossFade(
                      isLoading: isLoading.value,
                      child: child ?? Container(),
                    ),
                    onPressed: onTapped,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(
                          softenColor(button.color ?? styleContext.emphasisColor).withOpacity(0.3)),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: button.borderRadius ?? BorderRadius.circular(12))),
                    ),
                  )
                : TextButton.icon(
                    onPressed: onTapped,
                    icon: _loadingCrossFade(
                      isLoading: isLoading.value,
                      child: leading,
                    ),
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
      },
    );
  }

  Widget menuButton(BuildContext context, StyleContext styleContext, StyledMenuButton menuButton) {
    return actionButton(
      context,
      actions: menuButton.actions,
      color: menuButton.emphasis.map(
        high: () => styleContext.emphasisColor,
        medium: () => styleContext.foregroundColor,
        low: () => styleContext.backgroundColorSoft,
      ),
    );
  }

  @override
  Widget textField(BuildContext context, StyleContext styleContext, StyledTextField textField) {
    final label = textField.labelText.mapIfNonNull((label) => StyledContentSubtitleText(label)) ?? textField.label;

    if (textField.backgroundColor != null) {
      styleContext = styleContextFromBackground(textField.backgroundColor!);
    }

    return HookBuilder(builder: (context) {
      final focusNode = useFocusNode();
      final isFocused = useState(false);
      useOneTimeEffect(() {
        final listener = () {
          isFocused.value = focusNode.hasFocus;
        };
        focusNode.addListener(listener);
        return () => focusNode.removeListener(listener);
      });
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) label,
            TextFormField(
              focusNode: focusNode,
              initialValue: textField.initialText,
              style: toTextStyle(styledTextStyle: bodyTextStyle(styleContext)).copyWith(
                color: styleContext.foregroundColor,
              ),
              readOnly: !textField.enabled,
              obscureText: textField.obscureText,
              maxLength: textField.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              buildCounter: (context, {required int currentLength, required bool isFocused, int? maxLength}) {
                if (maxLength == null) {
                  return null;
                }

                final delta = maxLength - currentLength;

                return delta < 20
                    ? StyledBodyText(
                        '$currentLength / $maxLength',
                        textOverrides: StyledTextOverrides(
                          fontColor: currentLength > maxLength ? Colors.red : null,
                        ),
                      )
                    : null;
              },
              decoration: InputDecoration(
                prefixIcon: textField.leading,
                suffixIcon: textField.trailing,
                fillColor: !textField.enabled || isFocused.value
                    ? styleContext.backgroundColor
                    : styleContext.backgroundColorSoft,
                focusColor: styleContext.foregroundColor,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                filled: true,
                errorText: textField.errorText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 1,
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
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 2,
                    color: styleContext.emphasisColor,
                  ),
                ),
                hintText: textField.hintText,
                hintStyle: toTextStyle(styledTextStyle: bodyTextStyle(styleContext)).copyWith(
                  color: styleContext.emphasisColorSoft,
                  fontStyle: FontStyle.italic,
                ),
              ),
              cursorColor: styleContext.emphasisColorSoft,
              onTap: textField.onTap,
              onChanged: textField.onChanged,
              maxLines: textField.maxLines,
              keyboardType: textField.keyboardType,
              textCapitalization: textField.textCapitalization ?? TextCapitalization.sentences,
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget dropdown<T>(BuildContext context, StyleContext styleContext, StyledDropdown<T> dropdown) {
    final label = dropdown.labelText.mapIfNonNull((label) => StyledContentSubtitleText(label)) ?? dropdown.label;
    final _builder = dropdown.builder ??
        (item) => StyledBodyText(
              item?.toString() ?? 'None',
              textOverrides: StyledTextOverrides(padding: EdgeInsets.zero),
            );

    final backgroundStyleContext = styleContextFromBackground(styleContext.backgroundColorSoft);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) label,
          DropdownButtonFormField<T?>(
            isExpanded: true,
            value: dropdown.value,
            dropdownColor: softenColor(styleContext.backgroundColorSoft),
            hint: StyledBodyText(
              'Select an option',
              textOverrides: StyledTextOverrides(
                fontColor: styleContext.emphasisColorSoft,
                padding: EdgeInsets.zero,
                fontStyle: FontStyle.italic,
              ),
            ),
            icon: StyledIcon(
              Icons.arrow_drop_down,
              paddingOverride: EdgeInsets.zero,
            ),
            style: toTextStyle(styledTextStyle: bodyTextStyle(backgroundStyleContext)),
            decoration: InputDecoration(
                errorText: dropdown.errorText,
                filled: true,
                fillColor: styleContext.backgroundColorSoft,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: styleContext.emphasisColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: styleContext.foregroundColor,
                    width: 1,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                )),
            items: [
              if (dropdown.canBeNone) null,
              ...dropdown.options,
            ]
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: StyleProvider(
                        style: this,
                        child: StyleContextProvider(
                          styleContext: backgroundStyleContext,
                          child: _builder(value),
                        ),
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
    final label = checkbox.labelText.mapIfNonNull((label) => StyledBodyText(
              label,
              textOverrides: StyledTextOverrides(
                padding: EdgeInsets.all(8),
                maxLines: 3,
              ),
            )) ??
        checkbox.label;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            if (label != null)
              Flexible(
                child: GestureDetector(
                  child: label,
                  onTap: checkbox.onChanged != null ? () => checkbox.onChanged!(!checkbox.value) : null,
                ),
              ),
          ],
        ),
        if (checkbox.errorText != null) StyledErrorText(checkbox.errorText!),
      ],
    );
  }

  Widget radio<T>(BuildContext context, StyleContext styleContext, StyledRadio<T> radio) {
    final label = radio.labelText.mapIfNonNull((label) => StyledContentSubtitleText(
              label,
              textOverrides: StyledTextOverrides(padding: EdgeInsets.zero),
            )) ??
        radio.label;
    return GestureDetector(
      onTap: radio.onChanged != null ? () => radio.onChanged!(radio.radioValue) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (label != null) label,
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
      labelText: dateField.labelText,
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
                        brightness: primaryColor.computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
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
  Widget colorPicker(BuildContext context, StyleContext styleContext, StyledColorPicker colorPicker) {
    final initialColor = colorPicker.color;
    return StyledTextField(
      key: ObjectKey(initialColor),
      labelText: colorPicker.labelText,
      label: colorPicker.label,
      errorText: colorPicker.errorText,
      leading: initialColor == null
          ? StyledIcon(Icons.radio_button_unchecked)
          : Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: 0, // Prevent it from fully expanding.
                decoration: BoxDecoration(
                  color: initialColor,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: styleContext.foregroundColor,
                      width: 3,
                    ),
                  ),
                ),
              ),
            ),
      hintText: 'Select a color',
      initialText: initialColor?.value.toRadixString(16).mapIfNonNull((color) => '#$color'),
      enabled: true,
      onTap: colorPicker.onChanged != null
          ? () async {
              final result = await showDialog(
                context: context,
                dialog: StyledDialog(
                  titleText: 'Select Color',
                  body: HookBuilder(
                    builder: (context) {
                      final selectedColor = useState<int?>(initialColor?.value);
                      final canBeNone = colorPicker.canBeNone;
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: colorPicker.allowedColors.map((color) {
                                final isSelected = selectedColor.value == color.value;
                                return GestureDetector(
                                  onTap: () {
                                    selectedColor.value = color.value;
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.fromBorderSide(
                                        BorderSide(
                                          color: initialStyleContext.foregroundColor,
                                          width: isSelected ? 3 : 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (canBeNone)
                                StyledButton.low(
                                  text: 'Clear',
                                  icon: Icons.clear,
                                  onTapped: () {
                                    selectedColor.value = null;
                                  },
                                ),
                              StyledButton.high(
                                text: 'Save',
                                icon: Icons.save,
                                onTapped: () {
                                  context.style().navigateBack(context: context, result: [selectedColor.value]);
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );

              FocusScope.of(context).requestFocus(FocusNode());

              if (result != null) {
                int? newColorValue = result[0];
                final newColor = newColorValue.mapIfNonNull((value) => Color(value));

                colorPicker.onChanged!(newColor);
              }
            }
          : null,
    );
  }

  @override
  Widget container(BuildContext context, StyleContext styleContext, StyledContainer container) {
    // Flat Style treats low and medium emphasis contents as the same.
    final backgroundColor = container.color ??
        container.emphasis.map<Color>(
          low: () => styleContext.backgroundColor,
          medium: () => styleContext.backgroundColorSoft,
          high: () => styleContext.emphasisColor,
        );

    final newStyleContext = styleContextFromBackground(backgroundColor);

    return StyleContextProvider(
      styleContext: newStyleContext,
      child: Padding(
        padding: container.padding ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: container.borderRadius ?? BorderRadius.zero,
          child: Material(
            color: backgroundColor,
            child: InkWell(
              onTap: container.onTapped,
              borderRadius: container.borderRadius,
              child: Container(
                width: container.width,
                height: container.height,
                child: container.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget content(BuildContext context, StyleContext styleContext, StyledContent content) {
    // Flat Style treats low and medium emphasis contents as the same.
    final backgroundColor = content.backgroundColorOverride ??
        content.emphasis.map<Color>(
          low: () => styleContext.backgroundColor,
          medium: () => styleContext.backgroundColorSoft,
          high: () => styleContext.emphasisColor,
        );

    final newStyleContext = styleContextFromBackground(backgroundColor).copyWith(
      emphasisColor: content.emphasisColorOverride,
    );

    final header = content.headerText != null ? StyledContentHeaderText(content.headerText!) : content.header;
    final body = content.bodyText != null ? StyledContentSubtitleText(content.bodyText!) : content.body;

    final highActions = content.actions.where((action) => action.emphasis == Emphasis.high).toList();
    final mediumActions = content.actions.where((action) => action.emphasis == Emphasis.medium).toList();
    final lowActions = content.actions.where((action) => action.emphasis == Emphasis.low).toList();

    return ClickableCard(
      elevation: 0,
      margin: content.paddingOverride ?? EdgeInsets.all(8),
      color: backgroundColor,
      borderRadius: content.borderRadius ?? BorderRadius.circular(12),
      splashColor: softenColor(backgroundColor).withOpacity(0.8),
      onTap: content.onTapped,
      onLongPress: lowActions.isEmpty
          ? null
          : () => showMenu(
                context: context,
                actions: lowActions,
              ),
      child: StyleContextProvider(
        styleContext: newStyleContext,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null ||
                body != null ||
                content.leading != null ||
                content.trailing != null ||
                mediumActions.isNotEmpty)
              MediaQuery(
                data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 14),
                  title: header != null ? header : body,
                  subtitle: header != null ? body : null,
                  leading: content.leading,
                  trailing: content.trailing != null || mediumActions.isNotEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (content.trailing != null) content.trailing!,
                            ...highActions.map((action) => _iconButtonFromAction(context, action: action)),
                            if (mediumActions.isNotEmpty)
                              actionButton(
                                context,
                                actions: mediumActions,
                              ),
                          ],
                        )
                      : null,
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

    final highActions = category.actions.where((action) => action.emphasis == Emphasis.high).toList();
    final lowMediumActions = category.actions.where((action) => action.emphasis != Emphasis.high).toList();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
      child: category.emphasis.map(
        high: () {
          return ClickableCard(
            elevation: 0,
            margin: category.paddingOverride ?? EdgeInsets.all(8),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      title: header != null ? header : body,
                      subtitle: header != null ? body : null,
                      leading: category.leading,
                      trailing: category.trailing != null || lowMediumActions.isNotEmpty || highActions.isNotEmpty
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (category.trailing != null) category.trailing!,
                                ...highActions.map((action) => _iconButtonFromAction(context, action: action)),
                                if (lowMediumActions.isNotEmpty)
                                  actionButton(
                                    context,
                                    actions: lowMediumActions,
                                  ),
                              ],
                            )
                          : null,
                    ),
                  if (category.children.isEmpty && category.noChildrenWidget != null) category.noChildrenWidget!,
                  ...category.children
                ],
              ),
            ),
          );
        },
        medium: () {
          return ClickableCard(
            elevation: 0,
            margin: category.paddingOverride ?? EdgeInsets.all(8),
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
                    Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        title: header != null ? header : body,
                        subtitle: header != null ? body : null,
                        leading: category.leading,
                        trailing: category.trailing != null || lowMediumActions.isNotEmpty || highActions.isNotEmpty
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (category.trailing != null) category.trailing!,
                                  ...highActions.map((action) => _iconButtonFromAction(context, action: action)),
                                  if (lowMediumActions.isNotEmpty)
                                    actionButton(
                                      context,
                                      actions: lowMediumActions,
                                    ),
                                ],
                              )
                            : null,
                      ),
                    ),
                  if (category.children.isEmpty && category.noChildrenWidget != null) category.noChildrenWidget!,
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 14),
                    title: header != null ? header : body,
                    subtitle: header != null ? body : null,
                    leading: category.leading,
                    trailing: category.trailing != null || lowMediumActions.isNotEmpty || highActions.isNotEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (category.trailing != null) category.trailing!,
                              ...highActions.map((action) => _iconButtonFromAction(context, action: action)),
                              if (lowMediumActions.isNotEmpty)
                                actionButton(
                                  context,
                                  actions: lowMediumActions,
                                ),
                            ],
                          )
                        : null,
                  ),
                if (category.children.isEmpty && category.noChildrenWidget != null) category.noChildrenWidget!,
                ...category.children
              ],
            ),
          );
        },
      ),
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
  Widget calendar(BuildContext context, StyleContext styleContext, StyledCalendar calendar) {
    return HookBuilder(builder: (context) {
      final focusedDay = useState<DateTime>(DateTime.now());
      final selectedDay = useState<DateTime>(DateTime.now());

      return TableCalendar<CalendarEvent>(
        focusedDay: focusedDay.value,
        selectedDayPredicate: (date) => selectedDay.value == date,
        eventLoader: (date) =>
            calendar.events.where((event) => event.date.withoutTime() == date.withoutTime()).toList(),
        onDaySelected: (selected, focused) {
          focusedDay.value = focused;
          selectedDay.value = selected;
          calendar.onDateSelected?.call(selected);
        },
        firstDay: DateTime.fromMicrosecondsSinceEpoch(0),
        lastDay: DateTime.now().add(Duration(days: 100000)),
        sixWeekMonthsEnforced: true,
        availableCalendarFormats: {CalendarFormat.month: 'Month'},
        calendarStyle: CalendarStyle(
          defaultTextStyle: toTextStyle(styledTextStyle: buttonTextStyle(styleContext)),
          weekendTextStyle:
              toTextStyle(styledTextStyle: buttonTextStyle(styleContext).copyWith(fontWeight: FontWeight.w500)),
          outsideTextStyle:
              toTextStyle(styledTextStyle: buttonTextStyle(styleContext).copyWith(fontWeight: FontWeight.w100)),
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: accentColor,
          ),
          markerSize: 14,
          markerDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: styleContext.emphasisColor.withOpacity(0.8),
          ),
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: styleContext.emphasisColorSoft.withOpacity(0.5),
          ),
        ),
        headerStyle: HeaderStyle(
          leftChevronIcon: StyledIcon.high(Icons.chevron_left),
          rightChevronIcon: StyledIcon.high(Icons.chevron_right),
          titleTextStyle: toTextStyle(styledTextStyle: contentHeaderTextStyle(styleContext)),
          titleCentered: true,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: toTextStyle(styledTextStyle: contentSubtitleTextStyle(styleContext)),
          weekendStyle: toTextStyle(styledTextStyle: contentSubtitleTextStyle(styleContext)),
        ),
        shouldFillViewport: true,
      );
    });
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
    final color = divider.emphasis.map(
      high: () => styleContext.emphasisColor.withOpacity(0.8),
      medium: () => styleContext.foregroundColor.withOpacity(0.7),
      low: () => styleContext.backgroundColorSoft.withOpacity(0.4),
    );
    return Divider(
      color: color,
      thickness: divider.thickness,
      indent: 4,
      endIndent: 4,
    );
  }

  @override
  Widget carousel(BuildContext context, StyleContext styleContext, StyledCarousel carousel) {
    return HookBuilder(
      builder: (context) {
        final pageController = useMemoized(() => carousel.pageController ?? PageController());
        final page = useState(pageController.initialPage);

        return Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: carousel.allowUserNavigation ? null : NeverScrollableScrollPhysics(),
                      scrollBehavior: CupertinoScrollBehavior(),
                      onPageChanged: (_page) => page.value = _page,
                      children: carousel.children,
                    ),
                  ),
                ],
              ),
            ),
            if (carousel.showNavigation && carousel.onSkip != null)
              Positioned(
                bottom: 10,
                left: 10,
                width: 100,
                child: SafeArea(
                  child: animatedFadeIn(
                    isVisible: page.value < carousel.children.length - 1,
                    child: StyledButton.low(
                      text: 'Skip',
                      onTapped: page.value < carousel.children.length - 1 ? () => carousel.onSkip!() : null,
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
                    count: carousel.children.length,
                    effect: WormEffect(
                      activeDotColor: primaryColor,
                      dotColor: styleContext.backgroundColorSoft,
                    ),
                  ),
                ),
              ),
              bottom: 20,
            ),
            if (carousel.showNavigation)
              Positioned(
                bottom: 10,
                right: 10,
                width: 100,
                child: SafeArea(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    child: page.value == carousel.children.length - 1
                        ? StyledButton.high(
                            key: ValueKey('done'), // Key is needed for AnimatedSwitcher to fade between buttons.
                            text: 'Done',
                            onTapped: carousel.onComplete,
                          )
                        : StyledButton.low(
                            key: ValueKey('next'),
                            text: 'Next',
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
        );
      },
    );
  }

  @override
  Future<T?> showDialog<T>({required BuildContext context, required StyledDialog<T> dialog}) async {
    final styleContext = initialStyleContext;

    final title = dialog.titleText.mapIfNonNull((titleText) => StyledContentHeaderText(
              titleText,
              textOverrides: StyledTextOverrides(
                textAlign: TextAlign.center,
                padding: EdgeInsets.zero,
              ),
            )) ??
        dialog.title;

    final body = dialog.bodyText.mapIfNonNull((bodyText) => StyledBodyText(bodyText)) ?? dialog.body;

    dialog.onShown?.call();

    final poppedValue = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      constraints: BoxConstraints.loose(Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
      )),
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StyleProvider(
          style: this,
          child: SingleChildScrollView(
            child: Padding(
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
                  child: Builder(
                    builder: (context) => Padding(
                      padding: EdgeInsets.all(2),
                      child: Column(
                        children: [
                          SizedBox(height: 3),
                          if (title != null)
                            _styledAppBar(
                              context,
                              title: title,
                            ),
                          body!,
                          SafeArea(
                            child: Container(),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    T? result = dialog.resultTransformer.mapIfNonNull((transformer) => transformer(poppedValue)) ?? poppedValue;

    dialog.onClosed?.call(result);

    return result;
  }

  @override
  Future<void> showMenu({required BuildContext context, required List<ActionItem> actions}) {
    return showDialog(
      context: context,
      dialog: StyledDialog(
        body: StyleContextProvider(
          styleContext: initialStyleContext,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: actions
                    .map<Widget>((action) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: initialStyleContext.backgroundColorSoft,
                            onTap: () {
                              Navigator.of(context).pop();
                              action.perform(context);
                            },
                            child: ListTile(
                              title: StyledContentSubtitleText(
                                action.name,
                                textOverrides: StyledTextOverrides(fontColor: action.color),
                              ),
                              subtitle: action.description != null ? StyledBodyText(action.description!) : null,
                              leading: action.icon
                                  .mapIfNonNull((icon) => StyledIcon(action.icon!, colorOverride: action.color)),
                            ),
                          ),
                        ))
                    .toList() +
                [SafeArea(child: Container())],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> showMessage({required BuildContext context, required StyledMessage message}) async {
    final backgroundColor = message.backgroundColorOverride ?? initialStyleContext.emphasisColorSoft;
    await ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: StyleProvider(
            style: this,
            child: StyleContextProvider(
              styleContext: styleContextFromBackground(backgroundColor),
              child: StyledBodyText(
                message.messageText,
              ),
            ),
          ),
          backgroundColor: backgroundColor,
          duration: message.showDuration,
        ))
        .closed;
  }

  @override
  Future<T?> navigateTo<T, P extends Widget>({
    required BuildContext context,
    required Widget Function(BuildContext context) page,
  }) {
    log('Navigating to $P');
    return Navigator.of(context).push(MaterialPageRoute(builder: page, settings: RouteSettings(name: '$P')));
  }

  @override
  void navigateBack<T>({required BuildContext context, T? result}) {
    log('Navigating Back');
    Navigator.of(context).pop(result);
  }

  @override
  void navigateReplacement<P extends Widget>(
      {required BuildContext context, required P Function(BuildContext context) newPage}) {
    log('Navigating Replacement to $P');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: newPage, settings: RouteSettings(name: '$P')));
  }

  Widget actionButton(
    BuildContext context, {
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
        showMenu(
          context: context,
          actions: actions,
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
    return luminance < 0.03 || luminance > 0.97;
  }

  /// An AnimatedCrossFade that fades between [child] and a loading indicator depending on whether [isLoading] is true.
  Widget _loadingCrossFade({Color? loadingIndicatorColor, required bool isLoading, required Widget child}) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 110),
      crossFadeState: isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: child,
      secondChild: Padding(
        padding: EdgeInsets.all(4),
        child: SizedBox(
          width: 24,
          child: AspectRatio(
            aspectRatio: 1,
            child: StyledLoadingIndicator(color: loadingIndicatorColor),
          ),
        ),
      ),
    );
  }

  Widget _iconButtonFromAction(BuildContext context, {required ActionItem action}) {
    return Tooltip(
      message: action.name,
      child: StyledIconButton(
        icon: action.icon ?? Icons.circle,
        onTapped: action.onPerform,
        color: action.color ?? context.styleContext().emphasisColor,
      ),
    );
  }

  /// Softens colors by making light colors darker and dark colors lighter.
  static Color softenColor(Color color) {
    if (color == Colors.white) {
      return color.darken(5);
    }

    final isAlmostWhite = color.computeLuminance() > 0.85;
    if (isAlmostWhite) {
      return Colors.white;
    }

    return color.computeLuminance() < 0.5 ? color.lighten() : color.darken(5);
  }
}
