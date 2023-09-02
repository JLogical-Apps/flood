import 'package:example_core/features/settings/settings.dart';
import 'package:example_core/features/settings/settings_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class SettingsRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<SettingsEntity, Settings>(
    SettingsEntity.new,
    Settings.new,
    entityTypeName: 'SettingsEntity',
    valueObjectTypeName: 'Settings',
  ).file('settings');
}
