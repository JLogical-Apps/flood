import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/src/automate/command/automate_command_context.dart';
import 'package:utils_core/utils_core.dart';
import 'package:xcodeproj/xcodeproj.dart';

extension AppAutomateCommandContextExtensions on AutomateCommandContext {
  Future<String> getAndroidIdentifier() async {
    final buildGradleFile = appDirectory / 'android' / 'app' - 'build.gradle';
    final buildGradle = await DataSource.static.file(buildGradleFile).get();
    final applicationId = RegExp(r'applicationId\s+"([^"]+)"').firstMatch(buildGradle);
    return applicationId?.group(1) ?? (throw Exception('Could not determine applicationId from build.gradle.'));
  }

  Future<String> getIosIdentifier() async {
    final xcodeFile = fileSystem.appDirectory / 'ios' - 'Runner.xcodeproj';
    final xcodeProject = XCodeProj(xcodeFile.path);

    final target = xcodeProject.targets.first;
    final buildConfiguration = target.buildConfigurationList!.buildConfigurations.first;
    return buildConfiguration.buildSettings['PRODUCT_BUNDLE_IDENTIFIER']!;
  }
}
