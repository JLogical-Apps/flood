import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';
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
