import 'package:example/presentation/utils/theme_mode_extensions.dart';
import 'package:example_core/features/local_settings/local_settings.dart';
import 'package:example_core/features/local_settings/local_settings_entity.dart';
import 'package:example_core/features/local_settings/theme_mode.dart' as theme;
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ThemeSwitcher extends HookWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final localSettingsModel = useSingleton(Query.from<LocalSettingsEntity>());

    useListen(
      useMemoized(() => localSettingsModel.stateX
          .whereLoaded()
          .map((localSettingsEntity) => localSettingsEntity.value.themeProperty.value)),
      (theme.ThemeMode themeMode) => context.styleAppComponent.style = themeMode.style,
    );

    return ModelBuilder(
      model: localSettingsModel,
      builder: (LocalSettingsEntity localSettingsEntity) {
        return localSettingsEntity.value.themeProperty.value == theme.ThemeMode.dark
            ? StyledButton(
                iconData: Icons.dark_mode,
                onPressed: () async {
                  await context.dropCoreComponent.updateEntity(
                    localSettingsEntity,
                    (LocalSettings user) => user..themeProperty.set(theme.ThemeMode.light),
                  );
                },
              )
            : StyledButton(
                iconData: Icons.light_mode,
                onPressed: () async {
                  await context.dropCoreComponent.updateEntity(
                    localSettingsEntity,
                    (LocalSettings user) => user..themeProperty.set(theme.ThemeMode.dark),
                  );
                },
              );
      },
    );
  }
}
