import 'package:example_core/features/tray/tray.dart';
import 'package:example_core/features/tray/tray_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TrayRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<TrayEntity, Tray>(
    TrayEntity.new,
    Tray.new,
    entityTypeName: 'TrayEntity',
    valueObjectTypeName: 'Tray',
  ).adapting('tray').withSecurity(RepositorySecurity.authenticated());
}