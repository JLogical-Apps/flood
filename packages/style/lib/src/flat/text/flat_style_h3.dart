import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h3.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleH3Renderer with IsTypedStyleRenderer<StyledH3> {
  @override
  Widget renderTyped(BuildContext context, StyledH3 component) {
    final colorPalette = context.colorPalette();
    return Text(
      component.text,
      textAlign: component.textAlign,
      style: TextStyle(
        fontSize: 26,
        color: colorPalette.foreground.getByEmphasis(component.emphasis),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Text', icon: Icons.text_fields).getSectionByNameOrCreate('H3')
      ..add(StyledText.h3.subtle('Subtle H3'))
      ..add(StyledText.h3('Regular H3'))
      ..add(StyledText.h3.strong('Strong H3'));
  }
}
