import 'package:collection/collection.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intersperse/intersperse.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/dialog/styled_dialog.dart';
import 'package:style/src/components/message/styled_message.dart';
import 'package:style/src/components/misc/styled_divider.dart';
import 'package:style/src/components/text/styled_markdown.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/delta/dialog/delta_style_dialog.dart';
import 'package:style/src/delta/input/delta_style_button.dart';
import 'package:style/src/delta/input/delta_style_checkbox.dart';
import 'package:style/src/delta/input/delta_style_chip.dart';
import 'package:style/src/delta/input/delta_style_color_picker.dart';
import 'package:style/src/delta/input/delta_style_date_time_field.dart';
import 'package:style/src/delta/input/delta_style_menu_button.dart';
import 'package:style/src/delta/input/delta_style_option_field.dart';
import 'package:style/src/delta/input/delta_style_radio_field.dart';
import 'package:style/src/delta/input/delta_style_text_field.dart';
import 'package:style/src/delta/layout/delta_style_card.dart';
import 'package:style/src/delta/layout/delta_style_container.dart';
import 'package:style/src/delta/layout/delta_style_list.dart';
import 'package:style/src/delta/layout/delta_style_tabs.dart';
import 'package:style/src/delta/media/delta_style_image.dart';
import 'package:style/src/delta/misc/delta_style_divider.dart';
import 'package:style/src/delta/misc/delta_style_icon.dart';
import 'package:style/src/delta/misc/delta_style_loading_indicator.dart';
import 'package:style/src/delta/misc/delta_style_scrollbar.dart';
import 'package:style/src/delta/page/delta_style_page.dart';
import 'package:style/src/delta/text/delta_style_text.dart';
import 'package:style/src/style.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:utils/utils.dart';

class DeltaStyle with IsStyle {
  final Color primaryColor;
  final Color backgroundColor;

  final List<StyleRenderer> renderers;
  final List<Widget> examples;

  DeltaStyle({
    this.primaryColor = const Color(0xffe39e43),
    this.backgroundColor = const Color(0xff141424),
  })  : renderers = [
          DeltaStyleCardRenderer(),
          DeltaStyleListRenderer(),
          DeltaStyleTextRenderer(),
          DeltaStyleTextFieldRenderer(),
          DeltaStyleCheckboxRenderer(),
          DeltaStyleDateFieldRenderer(),
          DeltaStyleColorPickerRenderer(),
          DeltaStyleButtonRenderer(),
          DeltaStyleChipRenderer(),
          DeltaStyleOptionFieldRenderer(),
          DeltaStyleRadioFieldRenderer(),
          DeltaStyleMenuButtonRenderer(),
          DeltaStyleImageRenderer(),
          DeltaStyleContainerRenderer(),
          DeltaStyleTabsRenderer(),
          DeltaStylePageRenderer(),
          DeltaStyleDividerRenderer(),
          DeltaStyleIconRenderer(),
          DeltaStyleLoadingIndicatorRenderer(),
          DeltaStyleDialogRenderer(),
          DeltaStyleScrollbarRenderer(),
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
    renderers.insert(0, renderer);
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
    final baseTextStyle = text.isDisplay ? GoogleFonts.urbanist : GoogleFonts.roboto;
    return baseTextStyle(
      fontSize: text.size.toDouble(),
      color: text.isError
          ? context.colorPalette().error.regular
          : text.color ?? context.colorPalette().foreground.getByEmphasis(text.emphasis),
      fontStyle: text.fontStyle,
      fontWeight: text.fontWeight,
      height: text.size > 18 ? 1.2 : 1,
    );
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
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: dialog,
          ),
        );
      },
    );
  }

  @override
  Future<void> showMessage(BuildContext context, StyledMessage message) async {
    final label = message.labelText?.mapIfNonNull((label) => StyledText.lg.centered(label)) ?? message.label;
    final backgroundColor = message.color ?? primaryColor;
    await ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: ColorPaletteProvider(
            colorPalette: getColorPaletteFromBackground(backgroundColor),
            child: label!,
          ),
          backgroundColor: backgroundColor,
        ))
        .closed;
  }

  @override
  ColorPalette getColorPaletteFromBackground(Color backgroundColor) {
    final isDark = backgroundColor.computeLuminance() < 0.28;
    final isCloseToPrimary = (backgroundColor - primaryColor) < 52000;

    final newBackground = isDarkMode
        ? (backgroundColor == Colors.black
            ? Color(0xff202020)
            : (isDark ? backgroundColor.lighten(10) : backgroundColor.darken(5)))
        : backgroundColor;
    final newForeground = isDark ? Colors.white : Colors.black;
    final newSubtleForeground = isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6);

    return ColorPalette(
      baseBackground: backgroundColor,
      strongBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(
        backgroundColor == primaryColor ? this.backgroundColor : primaryColor,
      ),
      regularBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(newBackground),
      subtleBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(backgroundColor),
      strongForegroundColorPaletteGetter: () => isCloseToPrimary
          ? getColorPaletteFromBackground(isDark ? Colors.white : Colors.black)
          : getColorPaletteFromBackground(primaryColor),
      regularForegroundColorPaletteGetter: () => isCloseToPrimary
          ? getColorPaletteFromBackground(isDark ? Colors.white : Colors.black)
          : getColorPaletteFromBackground(newForeground),
      subtleForegroundColorPaletteGetter: () => isCloseToPrimary
          ? getColorPaletteFromBackground(isDark ? Colors.white : Colors.black)
          : getColorPaletteFromBackground(newSubtleForeground),
      strongErrorColorPaletteGetter: () => getColorPaletteFromBackground(Colors.red.shade700),
      regularErrorColorPaletteGetter: () => getColorPaletteFromBackground(isDark ? Colors.red : Colors.red.shade700),
      subtleErrorColorPaletteGetter: () => getColorPaletteFromBackground(Colors.red.shade400),
    );
  }
}
