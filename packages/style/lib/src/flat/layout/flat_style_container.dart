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
        child: InkWell(
          onTap: component.onPressed,
          onLongPress: component.onLongPressed,
          borderRadius: component.shape == null ? BorderRadius.circular(12) : null,
          customBorder: component.shape,
          child: Container(
            width: component.width,
            height: component.height,
            child: component.child?.mapIfNonNull((child) => Padding(
                  padding: component.padding,
                  child: child,
                )),
          ),
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
        padding: EdgeInsets.all(8),
        onPressed: () {
          print('Hello World!');
        },
        child: StyledList.column(
          children: [
            StyledText.xl.centered('Subtle Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(
                  child: StyledText.xl('Subtle Container'),
                  padding: EdgeInsets.all(8),
                ),
                StyledContainer(
                  child: StyledText.xl('Regular Container'),
                  padding: EdgeInsets.all(8),
                ),
                StyledContainer.strong(
                  child: StyledText.xl('Strong Container'),
                  padding: EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ))
      ..add(StyledContainer(
        padding: EdgeInsets.all(8),
        child: StyledList.column(
          children: [
            StyledText.xl.centered('Regular Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(
                  child: StyledText.xl('Subtle Container'),
                  padding: EdgeInsets.all(8),
                ),
                StyledContainer(
                  child: StyledText.xl('Regular Container'),
                  padding: EdgeInsets.all(8),
                ),
                StyledContainer.strong(
                  child: StyledText.xl('Strong Container'),
                  padding: EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ))
      ..add(StyledContainer.strong(
        padding: EdgeInsets.all(8),
        child: StyledList.column(
          children: [
            StyledText.xl.centered('Strong Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(
                  child: StyledText.xl('Subtle Container'),
                  padding: EdgeInsets.all(8),
                ),
                StyledContainer(
                  child: StyledText.xl('Regular Container'),
                  padding: EdgeInsets.all(8),
                ),
                StyledContainer.strong(
                  child: StyledText.xl('Strong Container'),
                  padding: EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ));
  }
}
