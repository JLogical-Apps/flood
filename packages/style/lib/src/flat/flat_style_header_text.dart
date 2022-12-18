import 'package:flutter/material.dart';
import 'package:style/src/components/styled_header_text.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyleHeaderText with IsTypedStyleRenderer<StyledHeaderText> {
  @override
  Widget renderTyped(StyledHeaderText component) {
    return Text('Test');
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide
        .getPageByNameOrCreate('Text', icon: Icons.text_fields)
        .getSectionByNameOrCreate('Header')
        .add(StyledHeaderText('Header'));
  }
}
