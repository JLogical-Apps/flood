import 'package:example/presentation/style.dart';
import 'package:example_core/features/local_settings/theme_mode.dart';
import 'package:flood/flood.dart';

extension ThemeModeExtensions on ThemeMode {
  Style get style => switch (this) {
        ThemeMode.light => lightStyle,
        ThemeMode.dark => darkStyle,
      };
}
