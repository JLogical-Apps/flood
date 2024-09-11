import 'package:example_core/features/local_settings/local_settings.dart';
import 'package:example_core/features/local_settings/local_settings_entity.dart';
import 'package:flood_core/flood_core.dart';

class LocalSettingsRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<LocalSettingsEntity, LocalSettings>(
    LocalSettingsEntity.new,
    LocalSettings.new,
    entityTypeName: 'LocalSettingsEntity',
    valueObjectTypeName: 'LocalSettings',
  ).adaptingToDevice('local-settings');
}
