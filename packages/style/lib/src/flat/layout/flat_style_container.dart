import 'package:flutter/material.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/emphasis.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleContainerRenderer with IsTypedStyleRenderer<StyledContainer> {
  @override
  Widget renderTyped(BuildContext context, StyledContainer component) {
    final backgroundColorPalette = context.colorPalette().background.getByEmphasis(component.emphasis);
    return ColorPaletteProvider(
      colorPalette: backgroundColorPalette,
      child: Container(
        width: component.width,
        height: component.height,
        child: component.child,
        decoration: BoxDecoration(
          color: backgroundColorPalette.baseBackground,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Text', icon: Icons.layers_outlined).getSectionByNameOrCreate('Container')
      ..add(StyledContainer(
        width: 200,
        height: 200,
        emphasis: Emphasis.subtle,
        child: StyledText.h1('Subtle Container'),
      ))
      ..add(StyledContainer(
        width: 200,
        height: 200,
        child: Center(child: StyledText.h1('Regular Container')),
      ))
      ..add(StyledContainer(
        width: 200,
        height: 200,
        emphasis: Emphasis.strong,
        child: StyledText.h1('Strong Container'),
      ));
  }
}
