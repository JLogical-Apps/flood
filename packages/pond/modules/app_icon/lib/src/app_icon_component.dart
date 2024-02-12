import 'dart:io';

import 'package:image/image.dart' as image;
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
    await iosAssetsFolder.ensureCreated();

    final configurationFile = await context.createTempFile('flutter_launcher_icons.yaml');
    await DataSource.static.file(configurationFile).mapYaml().set(await _constructConfig(context));

    context.appProject.run('flutter pub run flutter_launcher_icons:main -f "${configurationFile.absolute.path}"');
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.empty;

  Future<Map<String, dynamic>> _constructConfig(AutomateCommandContext context) async {
    final appIconForegroundFile = appIconForegroundFileGetter(context.appDirectory);
    final imagePath = (await _constructAppIcon(context, foregroundImageFile: appIconForegroundFile)).absolute.path;
    return {
      'flutter_icons': {
        'android': true,
        'ios': true,
        'remove_alpha_ios': true,
        'image_path': imagePath,
        'adaptive_icon_background': '#${backgroundColor.toRadixString(16)}',
        'adaptive_icon_foreground': appIconForegroundFile.relativePath,
        'web' : {
          'generate': true,
        },
      },
    };
  }

  Future<File> _constructAppIcon(AutomateCommandContext context, {required File foregroundImageFile}) async {
    final foregroundImage = image.decodeImage(await foregroundImageFile.readAsBytes()) ??
        (throw Exception('Cannot load the foreground image!'));

    final appIconImage = _scaleImageCentered(
      source: foregroundImage,
      colorBackground: _getColor(backgroundColor),
      maxWidth: 1024,
      maxHeight: 1024,
      padding: padding,
    );

    final outputFile = await context.createTempFile('app_icon.png');

    await outputFile.writeAsBytes(image.encodePng(appIconImage));

    return outputFile;
  }

  image.Color _getColor(int rgb) {
    return image.ColorRgb8(
      (rgb & 0xff0000) >>> 16,
      (rgb & 0x00ff00) >>> 8,
      rgb & 0x0000ff,
    );
  }

  image.Image _scaleImageCentered({
    required image.Image source,
    required int maxWidth,
    required int maxHeight,
    required image.Color colorBackground,
    int padding = 0,
  }) {
    final scaleX = maxWidth / source.width;
    final scaleY = maxHeight / source.height;
    final scale = (scaleX * source.height > maxHeight) ? scaleY : scaleX;
    final width = (source.width * scale).round() - padding * 2;
    final height = (source.height * scale).round() - padding * 2;
    return image.compositeImage(
      image.fill(image.Image(width: maxWidth, height: maxHeight), color: colorBackground),
      source,
      blend: image.BlendMode.alpha,
      dstX: ((maxWidth - width) / 2).round(),
      dstY: ((maxHeight - height) / 2).round(),
      dstW: width,
      dstH: height,
    );
  }
}
