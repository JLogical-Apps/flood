import 'package:example/presentation/style.dart';
import 'package:example_core/features/local_settings/local_settings.dart';
import 'package:example_core/features/local_settings/local_settings_entity.dart';
import 'package:example_core/features/local_settings/theme_mode.dart' as theme;
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StyleSwitcher extends HookWidget {
  const StyleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localSettingsModel = useSingleton(Query.from<LocalSettingsEntity>());
    return ModelBuilder(
      model: localSettingsModel,
      builder: (LocalSettingsEntity localSettingsEntity) {
        return localSettingsEntity.value.themeProperty.value == theme.ThemeMode.dark
            ? StyledButton(
                iconData: Icons.dark_mode,
                onPressed: () async {
                  context.styleAppComponent.style = lightStyle;
                  await context.dropCoreComponent.updateEntity(
                    localSettingsEntity,
                    (LocalSettings localSettings) => localSettings..themeProperty.set(theme.ThemeMode.light),
                  );
                },
              )
            : StyledButton(
                iconData: Icons.light_mode,
                onPressed: () async {
                  context.styleAppComponent.style = darkStyle;
                  await context.dropCoreComponent.updateEntity(
                    localSettingsEntity,
                    (LocalSettings localSettings) => localSettings..themeProperty.set(theme.ThemeMode.dark),
                  );
                },
              );
      },
    );
  }
}
