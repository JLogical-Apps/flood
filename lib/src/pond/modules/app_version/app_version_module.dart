import 'package:jlogical_utils/src/pond/record/singleton.dart';

import '../../../patterns/export_core.dart';
import '../../../persistence/export_core.dart';
import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import '../../query/query.dart';
import '../debug/debuggable_module.dart';
import 'version_usage.dart';
import 'version_usage_entity.dart';
import 'version_usage_repository.dart';

class AppVersionModule extends AppModule implements DebuggableModule {
  final DataSource<int>? currentVersionProvider;
  final DataSource<int>? minimumVersionProvider;

  late bool isFirstTimeOpened;
  late int? lastUsedVersion;
  late int? currentVersion;
  late int? minimumVersion;

  bool? get needsUpdate => currentVersion == null || minimumVersion == null ? null : currentVersion! < minimumVersion!;

  AppVersionModule({this.currentVersionProvider, this.minimumVersionProvider});

  @override
  void onRegister(AppRegistration registration) {
    registration.register(VersionUsageRepository());
  }

  Future<void> onLoad(AppContext context) async {
    var singletonExisted = true;
    final versionUsageEntity =
        await Singleton.getOrCreate<VersionUsageEntity, VersionUsage>(beforeCreate: (e) => singletonExisted = false);

    isFirstTimeOpened = !singletonExisted;
    lastUsedVersion = versionUsageEntity.value.versionProperty.value;
    currentVersion = await currentVersionProvider?.getData();
    minimumVersion = await minimumVersionProvider?.getData();

    versionUsageEntity.value = VersionUsage()..versionProperty.value = currentVersion;

    await versionUsageEntity.save();
  }

  @override
  Future<void> onReset(AppContext context) async {
    final versionUsages = await Query.from<VersionUsageEntity>().all().get();
    for (final versionUsage in versionUsages) {
      await versionUsage.delete();
    }
  }

  @override
  List<Command> get debugCommands => [
        SimpleCommand(
          name: 'get_version_info',
          displayName: 'Version Info',
          description: 'Gets the current version info.',
          runner: (args) {
            return {
              'currentVersion': currentVersion,
              'minimumVersion': minimumVersion,
            };
          },
        ),
      ];
}
