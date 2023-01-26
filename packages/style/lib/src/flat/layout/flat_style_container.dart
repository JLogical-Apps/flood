import 'package:flutter/material.dart';
import 'package:style/src/color_palette.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/flat/flat_style.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:utils/utils.dart';

class FlatStyleContainerRenderer with IsTypedStyleRenderer<StyledContainer> {
  @override
  Widget renderTyped(BuildContext context, StyledContainer component) {
    final backgroundColorPalette = getBackgroundColor(context, container: component);
    return ColorPaletteProvider(
      colorPalette: backgroundColorPalette,
      child: Material(
        color: backgroundColorPalette.baseBackground,
        borderRadius: component.shape == null ? BorderRadius.circular(12) : null,
        shape: component.shape,
        child: Container(
          width: component.width,
          height: component.height,
          child: component.child?.mapIfNonNull((child) => Padding(
                padding: component.padding,
                child: child,
              )),
        ),
      ),
    );
  }

  ColorPalette getBackgroundColor(BuildContext context, {required StyledContainer container}) {
    final flatStyle = context.style() as FlatStyle;

    final color = container.color;
    if (color != null) {
      if (color.opacity < 1) {
        final mixedColor = context.colorPalette().baseBackground.mix(color, (color.opacity * 100).round());
        return flatStyle.getColorPaletteFromBackground(mixedColor);
      }
      return flatStyle.getColorPaletteFromBackground(color);
    }

    return context.colorPalette().background.getByEmphasis(container.emphasis);
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Containers', icon: Icons.layers_outlined).getSectionByNameOrCreate('Container')
      ..add(StyledContainer.subtle(
        child: StyledList.column(
          children: [
            StyledText.h3.centered('Subtle Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(child: StyledText.h3('Subtle Container')),
                StyledContainer(child: StyledText.h3('Regular Container')),
                StyledContainer.strong(child: StyledText.h3('Strong Container')),
              ],
            ),
          ],
        ),
      ))
      ..add(StyledContainer(
        child: StyledList.column(
          children: [
            StyledText.h3.centered('Regular Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(child: StyledText.h3('Subtle Container')),
                StyledContainer(child: StyledText.h3('Regular Container')),
                StyledContainer.strong(child: StyledText.h3('Strong Container')),
              ],
            ),
          ],
        ),
      ))
      ..add(StyledContainer.strong(
        child: StyledList.column(
          children: [
            StyledText.h3.centered('Strong Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(child: StyledText.h3('Subtle Container')),
                StyledContainer(child: StyledText.h3('Regular Container')),
                StyledContainer.strong(child: StyledText.h3('Strong Container')),
              ],
            ),
          ],
        ),
      ));
  }
}
