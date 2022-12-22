import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyleAppComponent with IsAppPondComponent {
  final Style style;

  StyleAppComponent({required this.style});

  @override
  Widget wrapApp(AppPondContext context, Widget app) {
    return Provider<Style>(
      child: ColorPaletteProvider(
        colorPalette: style.colorPalette,
        child: app,
      ),
      create: (_) => style,
    );
  }
}
