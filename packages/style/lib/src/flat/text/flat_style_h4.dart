import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h4.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleH4Renderer with IsTypedStyleRenderer<StyledH4> {
  @override
  Widget renderTyped(BuildContext context, StyledH4 component) {
    final colorPalette = context.colorPalette();
    return Text(
      component.text,
      textAlign: component.textAlign,
      style: TextStyle(
        fontSize: 22,
        color: colorPalette.foreground.getByEmphasis(component.emphasis),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Text', icon: Icons.text_fields).getSectionByNameOrCreate('H4')
      ..add(StyledText.h4.subtle('Subtle H4'))
      ..add(StyledText.h4('Regular H4'))
      ..add(StyledText.h4.strong('Strong H4'));
  }
}
