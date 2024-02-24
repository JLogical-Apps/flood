import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:release/src/release_context.dart';
import 'package:release/src/release_platform.dart';
import 'package:utils_core/utils_core.dart';
import 'package:xcodeproj/xcodeproj.dart';

class IosReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'ios';

  @override
  String get title => 'iOS';

  @override
  Future onBuild(AutomateCommandContext context, ReleaseContext releaseContext) async {
    final workspace = (context.appDirectory / 'ios' - 'Runner.xcworkspace').path;
    final outputDirectory = (context.appDirectory / 'build' / 'ios').path;

    final exportOptionsFile = await getExportOptionsFile(context, releaseContext);

    await context.appProject.run(
      'fastlane gym build '
      '--workspace $workspace '
      '--scheme Runner '
      '--output_directory $outputDirectory '
      '--output_name Runner.ipa '
      '--export_method ${releaseContext.isDebug ? 'ad-hoc' : 'app-store'} '
      '--export_options ${exportOptionsFile.path} '
      '--silent '
      '--suppress_xcode_output '
      '${releaseContext.isDebug ? '--skip_profile_detection ' : ''}',
    );
  }

  Future<File> getExportOptionsFile(AutomateCommandContext context, ReleaseContext releaseContext) async {
    final identifier = getIdentifier(context);

    final plistFile = await context.createTempFile('ExportOptions.plist');
    await DataSource.static.file(plistFile).set('''\
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>provisioningProfiles</key>
    <dict>
      <key>$identifier</key>
      <string>match ${releaseContext.isDebug ? 'AdHoc' : 'AppStore'} $identifier</string>
    </dict>
</dict>
</plist>
''');

    return plistFile;
  }

  String getIdentifier(AutomateCommandContext context) {
    final xcodeFile = context.fileSystem.appDirectory / 'ios' - 'Runner.xcodeproj';
    final xcodeProject = XCodeProj(xcodeFile.path);

    final target = xcodeProject.targets.first;
    final buildConfiguration = target.buildConfigurationList!.buildConfigurations.first;
    return buildConfiguration.buildSettings['PRODUCT_BUNDLE_IDENTIFIER']!;
  }
}
