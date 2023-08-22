import 'dart:io';

import 'package:image/image.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class AppIconAutomateComponent with IsAutomatePondComponent {
  final File Function(Directory appDirectory) appIconForegroundFileGetter;
  final int backgroundColor;
  final int padding;

  AppIconAutomateComponent({
    required this.appIconForegroundFileGetter,
    required this.backgroundColor,
    this.padding = 0,
  });

  @override
  List<AutomateCommand> get commands => [
        AppIconCommand(
          appIconForegroundFileGetter: appIconForegroundFileGetter,
          backgroundColor: backgroundColor,
          padding: padding,
        )
      ];
}

class AppIconCommand extends AutomateCommand<AppIconCommand> {
  final File Function(Directory rootDirectory) appIconForegroundFileGetter;
  final int backgroundColor;
  final int padding;

  AppIconCommand({
    required this.appIconForegroundFileGetter,
    required this.backgroundColor,
    required this.padding,
  });

  @override
  String get name => 'app_icon';

  @override
  String get description => 'Sets the app icon of the app.';

  @override
  AppIconCommand copy() {
    return AppIconCommand(
      appIconForegroundFileGetter: appIconForegroundFileGetter,
      backgroundColor: backgroundColor,
      padding: padding,
    );
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    await context.appProject.ensurePackageInstalled('flutter_launcher_icons', isDevDependency: true);

    // Sometimes the AppIcon.appiconset folder isn't created causing flutter_launcher_icons to crash.
    final iosAssetsFolder = context.appDirectory / 'ios' / 'Runner' / 'Assets.xcassets' / 'AppIcon.appiconset';
    iosAssetsFolder.ensureCreated();

    final configurationFile = await context.createTempFile('flutter_launcher_icons.yaml');
    await DataSource.static.file(configurationFile).mapYaml().set(await _constructConfig(context));

    context.appProject.run('flutter pub run flutter_launcher_icons:main -f "${configurationFile.absolute.path}"');
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.empty;

  Future<Map<String, dynamic>> _constructConfig(AutomateCommandContext context) async {
    final appIconForegroundFile = appIconForegroundFileGetter(context.appDirectory);
    return {
      'flutter_icons': {
        'android': true,
        'ios': true,
        'remove_alpha_ios': true,
        'image_path': (await _constructAppIcon(context, foregroundImageFile: appIconForegroundFile)).absolute.path,
        'adaptive_icon_background': '#${backgroundColor.toRadixString(16)}',
        'adaptive_icon_foreground': appIconForegroundFile.relativePath,
      },
    };
  }

  Future<File> _constructAppIcon(AutomateCommandContext context, {required File foregroundImageFile}) async {
    final foregroundImage =
        decodeImage(await foregroundImageFile.readAsBytes()) ?? (throw Exception('Cannot load the foreground image!'));

    final image = _scaleImageCentered(
      source: foregroundImage,
      colorBackground: _getColor(backgroundColor),
      maxWidth: 1024,
      maxHeight: 1024,
      padding: padding,
    );

    final outputFile = await context.createTempFile('app_icon.png');

    await outputFile.writeAsBytes(encodePng(image));

    return outputFile;
  }

  int _getColor(int rgb) => Color.fromRgb((rgb & 0xff0000) >>> 16, (rgb & 0x00ff00) >>> 8, rgb & 0x0000ff);

  Image _scaleImageCentered({
    required Image source,
    required int maxWidth,
    required int maxHeight,
    required int colorBackground,
    int padding = 0,
  }) {
    final scaleX = maxWidth / source.width;
    final scaleY = maxHeight / source.height;
    final scale = (scaleX * source.height > maxHeight) ? scaleY : scaleX;
    final width = (source.width * scale).round() - padding * 2;
    final height = (source.height * scale).round() - padding * 2;
    return drawImage(
        Image(maxWidth, maxHeight)..fill(colorBackground),
        copyResize(
          source,
          width: width,
          height: height,
        ),
        dstX: ((maxWidth - width) / 2).round(),
        dstY: ((maxHeight - height) / 2).round());
  }
}
