import 'package:flutter/material.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/components/text/styled_text_builder.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/styled_text_renderer.dart';
import 'package:style/src/styleguide.dart';

abstract class StyleRenderer {
  bool shouldRender(BuildContext context, StyleComponent component);

  Widget render(BuildContext context, StyleComponent component);

  void modifyStyleguide(Styleguide styleguide);
}

mixin IsTypedStyleRenderer<S extends StyleComponent> implements StyleRenderer {
  @override
  bool shouldRender(BuildContext context, StyleComponent component) {
    return component is S;
  }

  Widget renderTyped(BuildContext context, S component);

  @override
  Widget render(BuildContext context, StyleComponent component) {
    return renderTyped(context, component as S);
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {}
}

mixin IsTextStyleRenderer<T extends StyledText> implements StyleRenderer, StyledTextRenderer {
  @override
  bool shouldRender(BuildContext context, StyleComponent component) {
    return component is T;
  }

  @override
  bool shouldWrap(StyledText text) {
    return text is T;
  }

  String get textName;

  StyledTextBuilder get baseTextBuilder;

  @override
  Widget render(BuildContext context, StyleComponent component) {
    final text = component as T;
    return Text(
      text.text,
      textAlign: component.textAlign,
      style: getTextStyle(context, text),
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Text', icon: Icons.text_fields).getSectionByNameOrCreate(textName)
      ..add(baseTextBuilder.subtle('Subtle $textName'))
      ..add(baseTextBuilder('Regular $textName'))
      ..add(baseTextBuilder.strong('Strong $textName'))
      ..add(baseTextBuilder.error('Error $textName'));
  }
}
