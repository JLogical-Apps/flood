import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:style/src/flat/flat_style_header_text.dart';
import 'package:style/src/style.dart';
import 'package:style/src/style_component.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';

class FlatStyle with IsStyle {
  final List<StyleRenderer> renderers;

  FlatStyle()
      : renderers = [
          FlatStyleHeaderText(),
        ];

  void addRenderer(StyleRenderer renderer) {
    renderers.add(renderer);
  }

  @override
  Widget render(StyleComponent component) {
    final renderer = renderers.firstWhereOrNull((renderer) => renderer.shouldRender(component));
    if (renderer == null) {
      throw Exception('Unrecognized component [$component]');
    }

    return renderer.render(component);
  }

  @override
  Styleguide getStyleguide() {
    final styleguide = Styleguide(pages: []);

    for (final renderer in renderers) {
      renderer.modifyStyleguide(styleguide);
    }

    return styleguide;
  }
}
