import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:style/src/color_palette.dart';

class ColorPaletteProvider extends StatelessWidget {
  final ColorPalette colorPalette;
  final Widget child;

  const ColorPaletteProvider({super.key, required this.colorPalette, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider(
      key: ValueKey(colorPalette),
      create: (_) => colorPalette,
      child: child,
    );
  }
}
