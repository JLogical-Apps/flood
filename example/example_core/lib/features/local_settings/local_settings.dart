import 'package:example_core/features/local_settings/theme_mode.dart';
import 'package:flood_core/flood_core.dart';

class LocalSettings extends ValueObject {
  static const themeField = 'theme';
  late final themeProperty = field<int>(name: themeField).hidden().asEnumIndex(ThemeMode.values);

  @override
  late final List<ValueObjectBehavior> behaviors = [themeProperty];
}
