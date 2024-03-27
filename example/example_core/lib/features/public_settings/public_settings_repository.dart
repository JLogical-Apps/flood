import 'package:example_core/features/public_settings/public_settings.dart';
import 'package:example_core/features/public_settings/public_settings_entity.dart';
import 'package:flood_core/flood_core.dart';

class PublicSettingsRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<PublicSettingsEntity, PublicSettings>(
    PublicSettingsEntity.new,
    PublicSettings.new,
    entityTypeName: 'PublicSettingsEntity',
    valueObjectTypeName: 'PublicSettings',
  ).adapting('public').withSecurity(RepositorySecurity.readWrite(
        read: Permission.all,
        write: Permission.none,
      ));
}
