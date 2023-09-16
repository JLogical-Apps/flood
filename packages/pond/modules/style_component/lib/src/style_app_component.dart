import 'package:flutter/material.dart' hide Route;
import 'package:pond/pond.dart';
import 'package:style/style.dart';
import 'package:style_component/src/styleguide_page.dart';

class StyleAppComponent with IsAppPondComponent {
  final Style style;

  StyleAppComponent({required this.style});

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return StyleProvider(
      style: style,
      child: app,
    );
  }

  @override
  Map<Route, AppPage> get pages => {
        StyleguideRoute(): StyleguidePage(),
      };
}
