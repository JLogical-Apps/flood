import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_category.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_checkbox.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_date_field.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_dropdown.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_radio.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_divider.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_onboarding_page.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_page.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_tabbed_page.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_content_header_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_subtitle_text.dart';
import 'package:provider/provider.dart';

import 'widgets/content/styled_content.dart';

/// Abstract class for all styles.
/// The Style defines all the building blocks of what a style should look like.
/// All building block [StyledWidget]s simply refer to their parent Style for how to be rendered.
abstract class Style {
  /// Simply allows subclasses to be const as well.
  const Style();

  /// The initial style context for the root of the style.
  StyleContext get initialStyleContext;

  // === PAGES ===

  /// A page.
  Widget page(BuildContext context, StyleContext styleContext, StyledPage page) => throw UnimplementedError();

  /// A page with tabs in it.
  Widget tabbedPage(BuildContext context, StyleContext styleContext, StyledTabbedPage tabbedPage) =>
      throw UnimplementedError();

  /// A page designed for onboarding.
  Widget onboardingPage(BuildContext context, StyleContext styleContext, StyledOnboardingPage onboardingPage) =>
      throw UnimplementedError();

  // === TEXT ===

  /// Text to be displayed as a title.
  Widget titleText(BuildContext context, StyleContext styleContext, StyledTitleText titleText) =>
      throw UnimplementedError();

  /// Text to be displayed under the title.
  Widget subtitleText(BuildContext context, StyleContext styleContext, StyledSubtitleText headerText) =>
      throw UnimplementedError();

  /// Text to be displayed as a header to content.
  Widget contentHeaderText(
          BuildContext context, StyleContext styleContext, StyledContentHeaderText contentHeaderText) =>
      throw UnimplementedError();

  /// Text to be displayed as a subtitle to content.
  Widget contentSubtitleText(
          BuildContext context, StyleContext styleContext, StyledContentSubtitleText contentSubtitleText) =>
      throw UnimplementedError();

  /// Text to be displayed in a body.
  Widget bodyText(BuildContext context, StyleContext styleContext, StyledBodyText bodyText) =>
      throw UnimplementedError();

  /// Text to be displayed in a button.
  Widget buttonText(BuildContext context, StyleContext styleContext, StyledButtonText buttonText) =>
      throw UnimplementedError();

  // === INPUT ===
  /// A button. This should respond to the button having different emphases.
  Widget button(BuildContext context, StyleContext styleContext, StyledButton primaryButton) =>
      throw UnimplementedError();

  /// A text field that handles taking in user input.
  Widget textField(BuildContext context, StyleContext styleContext, StyledTextField textField) =>
      throw UnimplementedError();

  /// A checkbox that accepts an on/off value.
  Widget checkbox(BuildContext context, StyleContext styleContext, StyledCheckbox checkbox) =>
      throw UnimplementedError();

  /// A radio button that is part of a radio group.
  Widget radio<T>(BuildContext context, StyleContext styleContext, StyledRadio<T> radio) => throw UnimplementedError();

  /// A dropdown that when tapped, allows the user to select a value.
  Widget dropdown<T>(BuildContext context, StyleContext styleContext, StyledDropdown<T> checkbox) =>
      throw UnimplementedError();

  /// A field that allows the user to select a date.
  Widget dateField(BuildContext context, StyleContext styleContext, StyledDateField dateField) =>
      throw UnimplementedError();

  // === CONTENT ===
  /// A container for content. This should respond to the content having different emphases.
  Widget content(BuildContext context, StyleContext styleContext, StyledContent content) => throw UnimplementedError();

  /// A category for anything, especially having [StyledContent]s as children. This should respond to the category
  /// having different emphases.
  Widget category(BuildContext context, StyleContext styleContext, StyledCategory contentGroup) =>
      throw UnimplementedError();

  // === MISC ===

  /// An icon. This should respond to the icon having different emphases.
  Widget icon(BuildContext context, StyleContext styleContext, StyledIcon icon) => throw UnimplementedError();

  /// A divider.
  Widget divider(BuildContext context, StyleContext styleContext, StyledDivider divider) => throw UnimplementedError();

  // === ACTIONS ===

  /// Displays a [dialog].
  Future<T> showDialog<T>({required BuildContext context, required StyledDialog dialog}) => throw UnimplementedError();

  /// Navigates to the [page] and returns the value given when [navigateBack] is called.
  Future<T?> navigateTo<T>({required BuildContext context, required Widget Function() page}) =>
      throw UnimplementedError();

  /// Navigates back and returns an optional [result].
  void navigateBack<T>({required BuildContext context, T? result}) => throw UnimplementedError();

  /// Replaces the current page with [newPage].
  void navigateReplacement({required BuildContext context, required Widget Function() newPage}) =>
      throw UnimplementedError();
}

extension BuildContextExtensions on BuildContext {
  /// Returns the style above this widget in the widget tree.
  Style style() {
    return Provider.of<Style>(this);
  }
}
