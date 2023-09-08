import 'dart:io';

import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';
import 'package:xcodeproj/xcodeproj.dart';

abstract class ReleasePlatform {
  String get name;

  Future build(AutomateCommandContext context);

  static final ReleasePlatform android = AndroidReleasePlatform();
  static final ReleasePlatform ios = IosReleasePlatform();
  static final ReleasePlatform web = WebReleasePlatform();
}

class AndroidReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'android';

  @override
  Future build(AutomateCommandContext context) async {
    await context.appProject.run('flutter build appbundle -t lib/app.dart');
  }
}

class IosReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'ios';

  @override
  Future build(AutomateCommandContext context) async {
    final workspace = (context.appDirectory / 'ios' - 'Runner.xcworkspace').path;
    final outputDirectory = (context.appDirectory / 'build' / 'ios').path;

    final exportOptionsFile = await getExportOptionsFile(context);

    await context.appProject.run(
      'fastlane gym build '
      '--workspace $workspace '
      '--scheme Runner '
      '--output_directory $outputDirectory '
      '--output_name Runner.ipa '
      '--export_method app-store '
      '--export_options ${exportOptionsFile.path} '
      '--clean '
      '--silent ',
    );
  }

  Future<File> getExportOptionsFile(AutomateCommandContext context) async {
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
		<string>match AppStore $identifier</string>
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

class WebReleasePlatform implements ReleasePlatform {
  @override
  String get name => 'web';

  @override
  Future build(AutomateCommandContext context) async {
    await context.appProject.run('flutter build web -t lib/app.dart');
  }
}
