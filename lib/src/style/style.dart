import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/style/style_context.dart';
import 'package:jlogical_utils/src/style/widgets/content/styled_category.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_button.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_checkbox.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_date_field.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_dropdown.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_menu_button.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_radio.dart';
import 'package:jlogical_utils/src/style/widgets/input/styled_text_field.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_chip.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_divider.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_icon.dart';
import 'package:jlogical_utils/src/style/widgets/misc/styled_message.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_dialog.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_onboarding_page.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_page.dart';
import 'package:jlogical_utils/src/style/widgets/pages/styled_tabbed_page.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_overrides.dart';
import 'package:jlogical_utils/src/style/widgets/text/styled_text_span.dart';
import 'package:provider/provider.dart';

import 'widgets/content/styled_content.dart';
import 'widgets/text/styled_text_style.dart';

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

  StyledTextStyle titleTextStyle(StyleContext styleContext) => throw UnimplementedError();

  StyledTextStyle subtitleTextStyle(StyleContext styleContext) => throw UnimplementedError();

  StyledTextStyle contentHeaderTextStyle(StyleContext styleContext) => throw UnimplementedError();

  StyledTextStyle contentSubtitleTextStyle(StyleContext styleContext) => throw UnimplementedError();

  StyledTextStyle bodyTextStyle(StyleContext styleContext) => throw UnimplementedError();

  StyledTextStyle buttonTextStyle(StyleContext styleContext) => throw UnimplementedError();

  Widget text(BuildContext context, StyleContext styleContext, StyledText text) => throw UnimplementedError();

  Widget textSpan(BuildContext context, StyleContext styleContext, StyledTextSpan textSpan) =>
      throw UnimplementedError();

  TextStyle toTextStyle({required StyledTextStyle styledTextStyle, StyledTextOverrides? overrides}) =>
      throw UnimplementedError();

  // === INPUT ===
  /// A button. This should respond to the button having different emphases.
  Widget button(BuildContext context, StyleContext styleContext, StyledButton primaryButton) =>
      throw UnimplementedError();

  /// A menu button. This should show a list of actions the user can take.
  Widget menuButton(BuildContext context, StyleContext styleContext, StyledMenuButton styledMenuButton) =>
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

  /// A chip. This should respond to the chip having different emphases.
  Widget chip(BuildContext context, StyleContext styleContext, StyledChip chip) => throw UnimplementedError();

  /// A divider.
  Widget divider(BuildContext context, StyleContext styleContext, StyledDivider divider) => throw UnimplementedError();

  // === ACTIONS ===

  /// Displays a [dialog].
  Future<T?> showDialog<T>({required BuildContext context, required StyledDialog<T> dialog}) =>
      throw UnimplementedError();

  Future<void> showMessage({required BuildContext context, required StyledMessage message}) =>
      throw UnimplementedError();

  /// Navigates to the [page] and returns the value given when [navigateBack] is called.
  Future<T?> navigateTo<T, P extends Widget>(
          {required BuildContext context, required P Function(BuildContext context) page}) =>
      throw UnimplementedError();

  /// Navigates back and returns an optional [result].
  void navigateBack<T>({required BuildContext context, T? result}) => throw UnimplementedError();

  /// Replaces the current page with [newPage].
  void navigateReplacement({required BuildContext context, required Widget Function(BuildContext context) newPage}) =>
      throw UnimplementedError();
}

extension BuildContextExtensions on BuildContext {
  /// Returns the style above this widget in the widget tree.
  Style style() {
    return Provider.of<Style>(this, listen: false);
  }

  /// Returns the StyleContext above this widget in the widget tree.
  StyleContext styleContext() {
    return Provider.of<StyleContext>(this, listen: false);
  }
}
