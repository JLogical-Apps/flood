import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyleProvider extends StatelessWidget {
  final Style style;
  final Widget child;

  const StyleProvider({super.key, required this.style, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider<Style>.value(
      value: style,
      child: ColorPaletteProvider(
        colorPalette: style.colorPalette,
        child: child,
      ),
    );
  }
}
