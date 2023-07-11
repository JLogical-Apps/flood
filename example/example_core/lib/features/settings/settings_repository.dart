import 'settings.dart';
import 'settings_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class SettingsRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.file('settings').forType<SettingsEntity, Settings>(
    SettingsEntity.new,
    Settings.new,
    entityTypeName: 'SettingsEntity',
    valueObjectTypeName: 'Settings',
  );
}
