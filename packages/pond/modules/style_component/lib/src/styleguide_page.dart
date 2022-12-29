import 'package:flutter/material.dart';
import 'package:path_core/path_core.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class StyleguidePage extends AppPage {
  StyleguidePage({super.key});

  @override
  PathDefinition get pathDefinition => PathDefinition.string('_styleguide');

  @override
  AppPage copy() {
    return StyleguidePage();
  }

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      titleText: 'Styleguide',
      body: StyleguideWidget(
        styleguide: context.style().getStyleguide(),
      ),
    );
  }
}
