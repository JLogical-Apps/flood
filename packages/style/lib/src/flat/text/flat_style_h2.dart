import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h2.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleH2Renderer with IsTypedStyleRenderer<StyledH2> {
  @override
  Widget renderTyped(BuildContext context, StyledH2 component) {
    final colorPalette = context.colorPalette();
    return Text(
      component.text,
      textAlign: component.textAlign,
      style: TextStyle(
        fontSize: 30,
        color: colorPalette.foreground.getByEmphasis(component.emphasis),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Text', icon: Icons.text_fields).getSectionByNameOrCreate('H2')
      ..add(StyledText.h2.subtle('Subtle H2'))
      ..add(StyledText.h2('Regular H2'))
      ..add(StyledText.h2.strong('Strong H2'));
  }
}
