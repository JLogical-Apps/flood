import 'package:flutter/material.dart';
import 'package:style/src/color_palette_provider.dart';
import 'package:style/src/components/input/styled_button.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleButtonRenderer with IsTypedStyleRenderer<StyledButton> {
  @override
  Widget renderTyped(BuildContext context, StyledButton component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body(text));
    final backgroundColorPalette = context.colorPalette().background.getByEmphasis(component.emphasis);
    return ElevatedButton(
      child: ColorPaletteProvider(colorPalette: backgroundColorPalette, child: label ?? Container()),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColorPalette),
        textStyle: MaterialStateProperty.all(context.style().getTextStyle(context, StyledText.button.empty)),
      ),
      onPressed: component.onPressed,
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Button')
      ..add(StyledList.row.withScrollbar(
        children: [
          StyledButton.subtle(
            labelText: 'Subtle',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton(
            labelText: 'Regular',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          ),
          StyledButton.strong(
            labelText: 'Strong',
            onPressed: () => Future.delayed(Duration(seconds: 1)),
          )
        ],
      ))
      ..add(StyledContainer.strong(
        child: StyledList.row.withScrollbar(
          children: [
            StyledButton.subtle(
              labelText: 'Subtle',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            ),
            StyledButton(
              labelText: 'Regular',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            ),
            StyledButton.strong(
              labelText: 'Strong',
              onPressed: () => Future.delayed(Duration(seconds: 1)),
            )
          ],
        ),
      ));
  }
}
