import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/flat/layout/flat_style_container.dart';
import 'package:style/src/flat/layout/flat_style_list.dart';
import 'package:style/src/flat/text/flat_style_header_text.dart';
import 'package:style/src/style.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyle with IsStyle {
  final Color primaryColor;
  final bool isDarkMode;

  final List<StyleRenderer> renderers;

  FlatStyle({this.primaryColor = Colors.blue, this.isDarkMode = false})
      : renderers = [
          FlatStyleListRenderer(),
          FlatStyleContainerRenderer(),
          FlatStyleH1Renderer(),
        ];

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
  ColorPalette get colorPalette => getColorPaletteFromBackground(isDarkMode ? Colors.black : Colors.white);

  ColorPalette getColorPaletteFromBackground(Color backgroundColor) {
    final regularForeground = backgroundColor == Colors.black ? Colors.white : Colors.black;
    return ColorPalette(
      baseBackground: backgroundColor,
      strongBackgroundColorPaletteGetter: () => backgroundColor == primaryColor
          ? getColorPaletteFromBackground(isDarkMode ? Colors.black : Colors.white)
          : getColorPaletteFromBackground(primaryColor),
      regularBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(backgroundColor),
      subtleBackgroundColorPaletteGetter: () => getColorPaletteFromBackground(backgroundColor.withOpacity(0.8)),
      strongForegroundColorPaletteGetter: () => backgroundColor == primaryColor
          ? getColorPaletteFromBackground(isDarkMode ? Colors.black : Colors.white)
          : getColorPaletteFromBackground(primaryColor),
      regularForegroundColorPaletteGetter: () => getColorPaletteFromBackground(regularForeground),
      subtleForegroundColorPaletteGetter: () => getColorPaletteFromBackground(regularForeground.withOpacity(0.8)),
    );
  }
}
