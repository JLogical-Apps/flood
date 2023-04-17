import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:intersperse/intersperse.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/misc/styled_divider.dart';
import 'package:style/src/components/text/styled_markdown.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/flat/dialog/flat_style_dialog.dart';
import 'package:style/src/flat/input/flat_style_button.dart';
import 'package:style/src/flat/input/flat_style_date_time_field.dart';
import 'package:style/src/flat/input/flat_style_menu_button.dart';
import 'package:style/src/flat/input/flat_style_option_field.dart';
import 'package:style/src/flat/input/flat_style_radio_field.dart';
import 'package:style/src/flat/input/flat_style_text_field.dart';
import 'package:style/src/flat/layout/flat_style_card.dart';
import 'package:style/src/flat/layout/flat_style_container.dart';
import 'package:style/src/flat/layout/flat_style_list.dart';
import 'package:style/src/flat/layout/flat_style_tabs.dart';
import 'package:style/src/flat/media/flat_style_image.dart';
import 'package:style/src/flat/misc/flat_style_divider.dart';
import 'package:style/src/flat/misc/flat_style_icon.dart';
import 'package:style/src/flat/misc/flat_style_loading_indicator.dart';
import 'package:style/src/flat/misc/flat_style_scrollbar.dart';
import 'package:style/src/flat/page/flat_style_page.dart';
import 'package:style/src/flat/text/flat_style_body_text.dart';
import 'package:style/src/flat/text/flat_style_button_text.dart';
import 'package:style/src/flat/text/flat_style_h1.dart';
import 'package:style/src/flat/text/flat_style_h2.dart';
import 'package:style/src/flat/text/flat_style_h3.dart';
import 'package:style/src/flat/text/flat_style_h4.dart';
import 'package:style/src/flat/text/flat_style_h5.dart';
import 'package:style/src/flat/text/flat_style_h6.dart';
import 'package:style/src/style.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styled_text_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:tinycolor2/tinycolor2.dart';

class FlatStyle with IsStyle {
  final Color primaryColor;
  final Color backgroundColor;

  final List<StyleRenderer> renderers;
  final List<Widget> examples;

  FlatStyle({
    this.primaryColor = const Color(0xffe39e43),
    this.backgroundColor = const Color(0xff141424),
  })  : renderers = [
          FlatStyleCardRenderer(),
          FlatStyleListRenderer(),
          FlatStyleH1Renderer(),
          FlatStyleH2Renderer(),
          FlatStyleH3Renderer(),
          FlatStyleH4Renderer(),
          FlatStyleH5Renderer(),
          FlatStyleH6Renderer(),
          FlatStyleBodyTextRenderer(),
          FlatStyleButtonTextRenderer(),
          FlatStyleTextFieldRenderer(),
          FlatStyleDateFieldRenderer(),
          FlatStyleButtonRenderer(),
          FlatStyleOptionFieldRenderer(),
          FlatStyleRadioFieldRenderer(),
          FlatStyleMenuButtonRenderer(),
          FlatStyleImageRenderer(),
          FlatStyleContainerRenderer(),
          FlatStyleTabsRenderer(),
          FlatStylePageRenderer(),
          FlatStyleDividerRenderer(),
          FlatStyleIconRenderer(),
          FlatStyleLoadingIndicatorRenderer(),
          FlatStyleDialogRenderer(),
          FlatStyleScrollbarRenderer(),
        ],
        examples = [
          StyledMarkdown('''# H1 heading

## H2 heading

### H3 heading

#### H4 heading

##### H5 heading

###### H6 heading

This is a paragraph of regular text.

This is a *italicized* word.

This is a **bolded** word.

This is a `code block`.

[This is a link](https://www.example.com)
''')
        ];

  bool get isDarkMode => backgroundColor.isDark;

  void addRenderer(StyleRenderer renderer) {
    renderers.add(renderer);
  }

  @override
  Widget render(BuildContext context, StyleComponent component) {
    final renderer = renderers.firstWhereOrNull((renderer) => renderer.shouldRender(context, component));
    if (renderer == null) {
      throw Exception('Unrecognized component [$component]');
    }

    return renderer.render(context, component);
  }

  @override
  Styleguide getStyleguide() {
    final styleguide = Styleguide(tabs: []);

    for (final renderer in renderers) {
      renderer.modifyStyleguide(styleguide);
    }

    examples.intersperse(StyledDivider()).forEach((widget) =>
        styleguide.getTabByNameOrCreate('Examples', icon: Icons.star).getSectionByNameOrCreate('Examples').add(widget));

    return styleguide;
  }

  @override
  late final ColorPalette colorPalette = getColorPaletteFromBackground(backgroundColor);

  @override
  TextStyle getTextStyle(BuildContext context, StyledText text) {
    return renderers
        .whereType<StyledTextRenderer>()
        .firstWhere((renderer) => renderer.shouldWrap(text))
        .getTextStyle(context, text);
  }

  @override
  Future<T?> showDialog<T>(BuildContext context, StyledDialog<T> dialog) async {
    final pageMediaQuery = MediaQuery.of(ScaffoldMessenger.maybeOf(context)?.context ?? context);
    return await flutter.showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      constraints: BoxConstraints.loose(Size(
        pageMediaQuery.size.width,
        pageMediaQuery.size.height - pageMediaQuery.padding.top,
      )),
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return dialog;
      },
    );
  }

  ColorPalette getColorPaletteFromBackground(Color backgroundColor) {
    final isDark = backgroundColor.computeLuminance() < 0.3;

    final newBackground = isDarkMode
        ? (backgroundColor == Colors.black
            ? Color(0xff202020)
            : (isDark ? backgroundColor.lighten(10) : backgroundColor.darken(5)))
        : (backgroundColor == this.backgroundColor ? Colors.white : this.backgroundColor);
    final newForeground = isDark ? Colors.white : Colors.black;
    final newSubtleForeground = isDark ? Color(0xffeeeeee) : Color(0xff111111);

    return ColorPalette(
      baseBackground: backgroundColor,
      strongBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(
        backgroundColor == primaryColor ? this.backgroundColor : primaryColor,
      ),
      regularBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(newBackground),
      subtleBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(backgroundColor),
      strongForegroundColorPaletteGetter: () => backgroundColor == primaryColor
          ? getColorPaletteFromBackground(isDark ? Colors.white : Colors.black)
          : getColorPaletteFromBackground(primaryColor),
      regularForegroundColorPaletteGetter: () => backgroundColor == primaryColor
          ? getColorPaletteFromBackground(isDark ? Colors.white : Colors.black)
          : getColorPaletteFromBackground(newForeground),
      subtleForegroundColorPaletteGetter: () => backgroundColor == primaryColor
          ? getColorPaletteFromBackground(isDark ? Colors.white : Colors.black)
          : getColorPaletteFromBackground(newSubtleForeground),
      strongErrorColorPaletteGetter: () => getColorPaletteFromBackground(Colors.red.shade700),
      regularErrorColorPaletteGetter: () => getColorPaletteFromBackground(Colors.red),
      subtleErrorColorPaletteGetter: () => getColorPaletteFromBackground(Colors.red.shade400),
    );
  }
}
