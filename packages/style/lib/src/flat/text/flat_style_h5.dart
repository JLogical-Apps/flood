import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_h5.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleH5Renderer with IsTypedStyleRenderer<StyledH5> {
  @override
  Widget renderTyped(BuildContext context, StyledH5 component) {
    final colorPalette = context.colorPalette();
    return Text(
      component.text,
      textAlign: component.textAlign,
      style: TextStyle(
        fontSize: 18,
        color: colorPalette.foreground.getByEmphasis(component.emphasis),
      ),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getPageByNameOrCreate('Text', icon: Icons.text_fields).getSectionByNameOrCreate('H5')
      ..add(StyledText.h5.subtle('Subtle H5'))
      ..add(StyledText.h5('Regular H5'))
      ..add(StyledText.h5.strong('Strong H5'));
  }
}
