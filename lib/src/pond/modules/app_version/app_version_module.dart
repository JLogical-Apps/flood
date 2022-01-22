import 'dart:io';

import 'package:jlogical_utils/jlogical_utils.dart';

import 'version_usage.dart';
import 'version_usage_entity.dart';
import 'version_usage_repository.dart';

class AppVersionModule extends AppModule {
  final Directory baseDirectory;

  final DataSource<int>? currentVersionProvider;
  final DataSource<int>? minimumVersionProvider;

  late int? lastUsedVersion;
  late int? currentVersion;
  late int? minimumVersion;

  bool get isFirstTimeOpened => lastUsedVersion == null;

  bool? get needsUpdate => currentVersion == null || minimumVersion == null ? null : currentVersion! < minimumVersion!;

  AppVersionModule({required this.baseDirectory, this.currentVersionProvider, this.minimumVersionProvider});

  @override
  void onRegister(AppRegistration registration) {
    registration.register(VersionUsageRepository(baseDirectory: baseDirectory));
  }

  Future<void> onLoad() async {
    VersionUsageEntity? versionUsageEntity = await Query.from<VersionUsageEntity>().firstOrNull().get();

    lastUsedVersion = versionUsageEntity?.value.versionProperty.value;
    currentVersion = await currentVersionProvider?.getData();
    minimumVersion = await minimumVersionProvider?.getData();

    final versionUsage = VersionUsage()..versionProperty.value = currentVersion;

    (versionUsageEntity ??= VersionUsageEntity())..value = versionUsage;

    await versionUsageEntity.createOrSave();
  }

  @override
  Future<void> onReset() async {
    final versionUsages = await Query.from<VersionUsageEntity>().all().get();
    for (final versionUsage in versionUsages) {
      await versionUsage.delete();
    }
  }
}
