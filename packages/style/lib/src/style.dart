import 'package:flutter/material.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/styleguide.dart';

abstract class Style {
  Widget render(StyleComponent component);

  Styleguide getStyleguide();
}

mixin IsStyle implements Style {}
