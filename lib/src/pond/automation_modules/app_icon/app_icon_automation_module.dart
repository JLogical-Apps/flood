import 'dart:io';

import 'package:image/image.dart';
import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

class AppIconAutomationModule extends AutomationModule {
  final File appIconForegroundFile;
  final int backgroundColor;

  String get name => 'App Icon';

  AppIconAutomationModule({required this.appIconForegroundFile, this.backgroundColor: 0xffffff}) {
    registerAutomation(
      name: 'app_icon',
      description: 'Set the app icon of the app.',
      action: _setAppIcon,
    );
  }

  @override
  Future<void> onBuild(AutomationContext context) async {
    if (context.isClean) {
      await _setAppIcon(context);
    }
  }

  Future<void> _setAppIcon(AutomationContext context) async {
    if (!await context.ensurePackageRegistered('flutter_launcher_icons', isDevDependency: true)) {
      context.error(
          "You don't have `flutter_launcher_icons` installed as a dev_dependency. It is needed in order to generate the app icon.");
      return;
    }

    final configurationFile = automateOutputDirectory - 'flutter_launcher_icons.yaml';
    context.print('Saving configuration into `${configurationFile.relativePath}`');
    await FileDataSource(file: configurationFile).mapYaml().saveData(await _constructConfig());

    context.run('flutter pub run flutter_launcher_icons:main -f ${configurationFile.relativePath}');
  }

  Future<Map<String, dynamic>> _constructConfig() async => {
        'flutter_icons': {
          'android': true,
          'ios': true,
          'remove_alpha_ios': true,
          'image_path': (await _constructAppIcon()).relativePath,
          'adaptive_icon_background': '#${backgroundColor.toRadixString(16)}',
          'adaptive_icon_foreground': appIconForegroundFile.relativePath,
        },
      };

  Future<File> _constructAppIcon() async {
    final foregroundImage = decodeImage(await appIconForegroundFile.readAsBytes()) ??
        (throw Exception('Cannot load the foreground image!'));
    final image = Image(foregroundImage.width, foregroundImage.height);

    fill(image, _renderedBackgroundColor);
    drawImage(image, foregroundImage);

    final outputFile = automateOutputDirectory - 'app_icon.png';
    await outputFile.ensureCreated();

    await outputFile.writeAsBytes(encodePng(image));

    return outputFile;
  }

  int get _renderedBackgroundColor => Color.fromRgb(
      (backgroundColor & 0xff0000) >>> 16, (backgroundColor & 0x00ff00) >>> 8, backgroundColor & 0x0000ff);
}
