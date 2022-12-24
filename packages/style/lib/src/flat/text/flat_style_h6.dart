import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h6.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleH6Renderer with IsTypedStyleRenderer<StyledH6> {
  @override
  Widget renderTyped(BuildContext context, StyledH6 component) {
    final colorPalette = context.colorPalette();
    return Text(
      component.text,
      textAlign: component.textAlign,
      style: TextStyle(
        fontSize: 16,
        color: colorPalette.foreground.getByEmphasis(component.emphasis),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Text', icon: Icons.text_fields).getSectionByNameOrCreate('H6')
      ..add(StyledText.h6.subtle('Subtle H6'))
      ..add(StyledText.h6('Regular H6'))
      ..add(StyledText.h6.strong('Strong H6'));
  }
}
