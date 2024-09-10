import 'dart:async';

import 'package:flutter/material.dart' hide Route;
import 'package:pond/pond.dart';
import 'package:rxdart/rxdart.dart';
import 'package:style/style.dart';
import 'package:style_component/src/styleguide_page.dart';
import 'package:utils/utils.dart';

class StyleAppComponent with IsAppPondComponent {
  final FutureOr<Style?> Function(AppPondContext context)? styleLoader;

  late final BehaviorSubject<Style> _styleX;

  ValueStream<Style> get styleX => _styleX;

  Style get style => _styleX.value;

  set style(Style style) => _styleX.value = style;

  StyleAppComponent({
    required Style style,
    this.styleLoader,
  }) : _styleX = BehaviorSubject.seeded(style);

  @override
  Future onLoad(AppPondContext context) async {
    if (styleLoader != null) {
      final newStyle = await styleLoader!(context);
      if (newStyle != null) {
        style = newStyle;
      }
    }
  }

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    final style = useValueStream(_styleX);
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

extension StyleComponentBuildContextExtensions on BuildContext {
  StyleAppComponent get styleAppComponent => find<StyleAppComponent>();
}
