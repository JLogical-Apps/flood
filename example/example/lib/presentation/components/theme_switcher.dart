import 'package:example/presentation/style.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ThemeSwitcher extends HookWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final style = useStyle();

    return style == darkStyle
        ? StyledButton(
            iconData: Icons.dark_mode,
            onPressed: () {
              context.styleAppComponent.style = lightStyle;
            },
          )
        : StyledButton(
            iconData: Icons.light_mode,
            onPressed: () {
              context.styleAppComponent.style = darkStyle;
            },
          );
  }
}
