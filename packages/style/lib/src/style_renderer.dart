import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/styleguide.dart';

abstract class StyleRenderer {
  bool shouldRender(StyleComponent component);

  Widget render(StyleComponent component);

  void modifyStyleguide(Styleguide styleguide);
}

mixin IsTypedStyleRenderer<S extends StyleComponent> implements StyleRenderer {
  @override
  bool shouldRender(StyleComponent component) {
    return component is S;
  }

  Widget renderTyped(S component);

  @override
  Widget render(StyleComponent component) {
    return renderTyped(component as S);
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {}
}
