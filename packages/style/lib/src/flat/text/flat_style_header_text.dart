import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h1.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleH1Renderer with IsTypedStyleRenderer<StyledH1> {
  @override
  Widget renderTyped(BuildContext context, StyledH1 component) {
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
    styleguide.getPageByNameOrCreate('Text', icon: Icons.text_fields).getSectionByNameOrCreate('Headings')
      ..add(StyledText.h1.subtle('Subtle H1'))
      ..add(StyledText.h1('Regular H1'))
      ..add(StyledText.h1.strong('Strong H1'));
  }
}
