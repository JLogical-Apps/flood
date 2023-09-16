import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class StyleguidePage extends AppPage<StyleguideRoute> {
  @override
  Widget onBuild(BuildContext context, StyleguideRoute route) {
    return StyledPage(
      titleText: 'Styleguide',
      body: StyleguideWidget(
        styleguide: context.style().getStyleguide(),
      ),
    );
  }
}

class StyleguideRoute with IsRoute<StyleguideRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_styleguide');

  @override
  StyleguideRoute copy() {
    return StyleguideRoute();
  }
}
