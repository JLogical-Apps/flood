import 'dart:async';

import 'package:environment/environment.dart';
import 'package:log/log.dart';
import 'package:persistence/persistence.dart';
import 'package:pond/pond.dart';
import 'package:version/version.dart';

class AppUsageAppComponent with IsAppPondComponent {
  final FutureOr<Version?> Function()? latestAllowedVersion;

  late bool isFirstRun;
  late Version currentVersion;

  AppUsageAppComponent({this.latestAllowedVersion});

  @override
  Future onLoad(AppPondContext context) async {
    await Future.wait([_loadIsFirstRun(context), _loadCurrentVersion()]);
    context.log('First time running the app: $isFirstRun. Current version: $currentVersion');
  }

  @override
  Future onReset(AppPondContext context) async {
    final appUsageDataSource = _getAppUsageDataSource(context);
    await appUsageDataSource.delete();
  }

  Future<bool> isOutdated() async {
    final latestAllowedVersion = await this.latestAllowedVersion?.call();
    if (latestAllowedVersion == null) {
      return false;
    }

    return currentVersion < latestAllowedVersion;
  }

  Future<void> _loadIsFirstRun(AppPondContext context) async {
    final appUsageDataSource = _getAppUsageDataSource(context);

    final appUsageYaml = await appUsageDataSource.getOrNull();

    if (appUsageYaml == null) {
      isFirstRun = true;
      await appUsageDataSource.set({'firstRun': false});
    } else {
      isFirstRun = false;
    }
  }

  Future<void> _loadCurrentVersion() async {
    final packageInfo =
        await DataSource.static.packageInfo().getOrNull() ?? (throw Exception('Could not retrieve package info!'));
    currentVersion = Version.parse(packageInfo.version);
  }

  DataSource<Map<String, dynamic>> _getAppUsageDataSource(AppPondContext context) => DataSource.static
      .crossFile(context.environmentCoreComponent.fileSystem.storageDirectory / 'app_usage' - 'app_usage.yaml')
      .mapYaml();
}
