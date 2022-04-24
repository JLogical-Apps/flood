import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/patterns/command/command.dart';
import 'package:jlogical_utils/src/patterns/command/simple_command.dart';
import 'package:jlogical_utils/src/pond/modules/debug/debuggable_module.dart';

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
          name: 'get_app_version',
          runner: (args) {
            return currentVersion;
          },
        ),
        SimpleCommand(
          name: 'get_min_version',
          runner: (args) {
            return minimumVersion;
          },
        )
      ];
}
