import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/flat/layout/flat_style_container.dart';
import 'package:style/src/flat/layout/flat_style_list.dart';
import 'package:style/src/flat/layout/flat_style_tabs.dart';
import 'package:style/src/flat/page/flat_style_page.dart';
import 'package:style/src/flat/text/flat_style_header_text.dart';
import 'package:style/src/style.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:tinycolor2/tinycolor2.dart';

class FlatStyle with IsStyle {
  final Color primaryColor;
  final Color backgroundColor;

  final List<StyleRenderer> renderers;

  FlatStyle({
    this.primaryColor = const Color(0xffe39e43),
    this.backgroundColor = const Color(0xff141424),
  }) : renderers = [
          FlatStyleListRenderer(),
          FlatStyleContainerRenderer(),
          FlatStyleTabsRenderer(),
          FlatStylePageRenderer(),
          FlatStyleH1Renderer(),
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
    final styleguide = Styleguide(pages: []);

    for (final renderer in renderers) {
      renderer.modifyStyleguide(styleguide);
    }

    return styleguide;
  }

  @override
  late final ColorPalette colorPalette = getColorPaletteFromBackground(backgroundColor);

  ColorPalette getColorPaletteFromBackground(Color backgroundColor) {
    final isDark = backgroundColor.isDark;

    final newBackground = isDarkMode
        ? (isDark ? backgroundColor.lighten(10) : backgroundColor.darken(5))
        : (backgroundColor == this.backgroundColor ? Colors.white : this.backgroundColor);
    final newSubtleBackground = isDarkMode
        ? (isDark ? backgroundColor.lighten(5) : backgroundColor.darken(3))
        : (backgroundColor == this.backgroundColor ? Colors.white : this.backgroundColor);
    final newForeground = isDark ? Colors.white : Colors.black;
    final newSubtleForeground = isDark ? Color(0xffeeeeee) : Color(0xff111111);

    return ColorPalette(
      baseBackground: backgroundColor,
      strongBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(
        backgroundColor == primaryColor
            ? isDark
                ? Colors.white
                : Colors.black
            : primaryColor,
      ),
      regularBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(newBackground),
      subtleBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(newSubtleBackground),
      strongForegroundColorPaletteGetter: () => backgroundColor == primaryColor
          ? getColorPaletteFromBackground(isDark ? Colors.white : Colors.black)
          : getColorPaletteFromBackground(primaryColor),
      regularForegroundColorPaletteGetter: () => getColorPaletteFromBackground(newForeground),
      subtleForegroundColorPaletteGetter: () => getColorPaletteFromBackground(newSubtleForeground),
    );
  }
}
