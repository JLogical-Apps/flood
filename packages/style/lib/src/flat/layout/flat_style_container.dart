import 'package:flutter/material.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleContainerRenderer with IsTypedStyleRenderer<StyledContainer> {
  @override
  Widget renderTyped(BuildContext context, StyledContainer component) {
    final backgroundColorPalette = context.colorPalette().background.getByEmphasis(component.emphasis);
    return ColorPaletteProvider(
      colorPalette: backgroundColorPalette,
      child: Container(
        width: component.width,
        height: component.height,
        child: component.child?.mapIfNonNull((child) => Padding(
              padding: component.padding,
              child: child,
            )),
        decoration: BoxDecoration(
          color: backgroundColorPalette.baseBackground,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Containers', icon: Icons.layers_outlined).getSectionByNameOrCreate('Container')
      ..add(StyledContainer.subtle(
        child: StyledList.column(
          children: [
            StyledText.h1.centered('Subtle Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(child: StyledText.h1('Subtle Container')),
                StyledContainer(child: StyledText.h1('Regular Container')),
                StyledContainer.strong(child: StyledText.h1('Strong Container')),
              ],
            ),
          ],
        ),
      ))
      ..add(StyledContainer(
        child: StyledList.column(
          children: [
            StyledText.h1.centered('Regular Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(child: StyledText.h1('Subtle Container')),
                StyledContainer(child: StyledText.h1('Regular Container')),
                StyledContainer.strong(child: StyledText.h1('Strong Container')),
              ],
            ),
          ],
        ),
      ))
      ..add(StyledContainer.strong(
        child: StyledList.column(
          children: [
            StyledText.h1.centered('Strong Container'),
            StyledList.row.withScrollbar(
              children: [
                StyledContainer.subtle(child: StyledText.h1('Subtle Container')),
                StyledContainer(child: StyledText.h1('Regular Container')),
                StyledContainer.strong(child: StyledText.h1('Strong Container')),
              ],
            ),
          ],
        ),
      ));
  }
}
