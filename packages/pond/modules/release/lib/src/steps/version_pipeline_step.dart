import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/pipeline_step.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';
import 'package:version/version.dart';
import 'package:xcodeproj/xcodeproj.dart';

class VersionPipelineStep with IsPipelineStep {
  @override
  String get name => 'version';

  @override
  Future execute(AutomateCommandContext context, List<ReleasePlatform> platforms) async {
    final pubspecYaml = await context.appProject.pubspecYamlDataSource.get();
    final currentVersionRaw = pubspecYaml['version'];
    final currentVersion = Version.parse(currentVersionRaw);
    final currentBuild = int.tryParse(currentVersion.build) ?? 1;

    final newVersion = getVersionInput(context, currentVersion: currentVersion).withBuild(currentBuild + 1);

    await updatePubspec(context, version: newVersion);
    if (platforms.contains(ReleasePlatform.ios)) {
      await updateXcode(context, version: newVersion);
    }
  }

  Version getVersionInput(AutomateCommandContext context, {required Version currentVersion}) {
    currentVersion = currentVersion.withoutBuild();
    while (true) {
      final newVersion = context.input(
        'What version would you like to set the app to? (Current version: [$currentVersion]): ',
      );
      final parsedVersion = guard(() => Version.parse(newVersion));
      if (parsedVersion == null) {
        context.print('[$newVersion] is not a valid version.');
        continue;
      }

      if (parsedVersion <= currentVersion) {
        context.print('[$newVersion] needs to be newer than the existing version [$currentVersion]');
        continue;
      }

      if (parsedVersion.build.isNotBlank) {
        context.print('[$newVersion] should not include a build number!');
        continue;
      }

      return parsedVersion;
    }
  }

  Future updatePubspec(AutomateCommandContext context, {required Version version}) async {
    for (final pubspecDataSource in [
      context.appProject.pubspecYamlDataSource,
      context.coreProject.pubspecYamlDataSource,
    ]) {
      await pubspecDataSource.update((pubspec) {
        pubspec!['version'] = version.toString();
        return pubspec;
      });
    }
  }

  Future updateXcode(AutomateCommandContext context, {required Version version}) async {
    final xcodeFile = context.fileSystem.appDirectory / 'ios' - 'Runner.xcodeproj';
    final xcodeProject = XCodeProj(xcodeFile.path);

    for (final target in xcodeProject.targets) {
      for (final buildConfiguration in target.buildConfigurationList!.buildConfigurations) {
        buildConfiguration.buildSettings['MARKETING_VERSION'] = version.toString();
      }
    }

    xcodeProject.save();
  }
}

extension VersionExtensions on Version {
  Version withoutBuild() {
    return Version(major, minor, patch);
  }

  Version withBuild(int build) {
    return Version(major, minor, patch, build: build.toString());
  }
}
