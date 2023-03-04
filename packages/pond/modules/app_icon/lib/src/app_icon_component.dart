import 'dart:io';

import 'package:image/image.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AppIconAutomateComponent with IsAutomatePondComponent {
  final File Function(Directory rootDirectory) appIconForegroundFileGetter;
  final int backgroundColor;

  AppIconAutomateComponent({
    required this.appIconForegroundFileGetter,
    required this.backgroundColor,
  });

  @override
  List<AutomateCommand> get commands => [
        AutomateCommand(
          name: 'app_icon',
          runner: (context) async {
            await context.ensurePackageInstalled('flutter_launcher_icons', isDevDependency: true);

            // Sometimes the AppIcon.appiconset folder isn't created causing flutter_launcher_icons to crash.
            final iosAssetsFolder =
                context.getRootDirectory() / 'ios' / 'Runner' / 'Assets.xcassets' / 'AppIcon.appiconset';
            iosAssetsFolder.ensureCreated();

            final configurationFile = await context.createTempFile('flutter_launcher_icons.yaml');
            context.print('Saving configuration into `${configurationFile.relativePath}`');
            await DataSource.static.file(configurationFile).mapYaml().set(await _constructConfig(context));

            context.run('flutter pub run flutter_launcher_icons:main -f "${configurationFile.relativePath}"');
          },
        ),
      ];

  Future<Map<String, dynamic>> _constructConfig(AutomateCommandContext context) async {
    final appIconForegroundFile = appIconForegroundFileGetter(context.getRootDirectory());
    return {
      'flutter_icons': {
        'android': true,
        'ios': true,
        'remove_alpha_ios': true,
        'image_path': (await _constructAppIcon(context, foregroundImageFile: appIconForegroundFile)).relativePath,
        'adaptive_icon_background': '#${backgroundColor.toRadixString(16)}',
        'adaptive_icon_foreground': appIconForegroundFile.relativePath,
      },
    };
  }

  Future<File> _constructAppIcon(AutomateCommandContext context, {required File foregroundImageFile}) async {
    final foregroundImage =
        decodeImage(await foregroundImageFile.readAsBytes()) ?? (throw Exception('Cannot load the foreground image!'));
    final image = Image(foregroundImage.width, foregroundImage.height);

    fill(image, _getColor(backgroundColor));
    drawImage(image, foregroundImage);

    final outputFile = await context.createTempFile('app_icon.png');

    await outputFile.writeAsBytes(encodePng(image));

    return outputFile;
  }

  int _getColor(int rgb) => Color.fromRgb((rgb & 0xff0000) >>> 16, (rgb & 0x00ff00) >>> 8, rgb & 0x0000ff);
}
