import 'package:example/presentation/style.dart';
import 'package:example_core/features/user/user_theme.dart';
import 'package:flood/flood.dart';

extension UserThemeExtensions on UserTheme {
  Style get style => switch (this) {
        UserTheme.light => lightStyle,
        UserTheme.dark => darkStyle,
      };
}
