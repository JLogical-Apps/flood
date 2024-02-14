import 'dart:io';

import 'package:image/image.dart' as image;
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:utils_core/utils_core.dart';

class NativeSetupAutomateComponent with IsAutomatePondComponent {
  final File Function(Directory appDirectory) appIconForegroundFileGetter;
  final int backgroundColor;
  final int padding;

  NativeSetupAutomateComponent({
    required this.appIconForegroundFileGetter,
    required this.backgroundColor,
    this.padding = 0,
  });

  @override
  List<AutomateCommand> get commands => [
        NativeSetupCommand(
          appIconForegroundFileGetter: appIconForegroundFileGetter,
          backgroundColor: backgroundColor,
          padding: padding,
        )
      ];
}

class NativeSetupCommand extends AutomateCommand<NativeSetupCommand> {
  final File Function(Directory rootDirectory) appIconForegroundFileGetter;
  final int backgroundColor;
  final int padding;

  NativeSetupCommand({
    required this.appIconForegroundFileGetter,
    required this.backgroundColor,
    required this.padding,
  });

  @override
  String get name => 'native_setup';

  @override
  String get description => 'Sets the app icon and native splash of the app.';

  @override
  NativeSetupCommand copy() {
    return NativeSetupCommand(
      appIconForegroundFileGetter: appIconForegroundFileGetter,
      backgroundColor: backgroundColor,
      padding: padding,
    );
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    await context.appProject.ensurePackageInstalled('flutter_launcher_icons', isDevDependency: true);
    await context.appProject.ensurePackageInstalled('flutter_native_splash', isDevDependency: true);

    // Sometimes the AppIcon.appiconset folder isn't created causing flutter_launcher_icons to crash.
    final iosAssetsFolder = context.appDirectory / 'ios' / 'Runner' / 'Assets.xcassets' / 'AppIcon.appiconset';
    await iosAssetsFolder.ensureCreated();

    final iconsConfigurationFile = await context.createTempFile('flutter_launcher_icons.yaml');
    await DataSource.static.file(iconsConfigurationFile).mapYaml().set(await _constructIconsConfig(context));
    context.appProject.run('flutter pub run flutter_launcher_icons -f "${iconsConfigurationFile.absolute.path}"');

    final splashConfigurationFile = await context.createTempFile('flutter_native_splash.yaml');
    await DataSource.static.file(splashConfigurationFile).mapYaml().set(await _constructSplashConfig(context));
    context.appProject
        .run('flutter pub run flutter_native_splash:create --path="${splashConfigurationFile.absolute.path}"');
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.empty;

  Future<Map<String, dynamic>> _constructIconsConfig(AutomateCommandContext context) async {
    final appIconForegroundFile = appIconForegroundFileGetter(context.appDirectory);
    final imagePath = (await _constructAppIcon(
      context,
      foregroundImageFile: appIconForegroundFile,
      hasBackground: true,
    ))
        .absolute
        .path;
    final foregroundImagePath = (await _constructAppIcon(
      context,
      foregroundImageFile: appIconForegroundFile,
      hasBackground: false,
    ))
        .absolute
        .path;
    return {
      'flutter_launcher_icons': {
        'android': true,
        'ios': true,
        'remove_alpha_ios': true,
        'image_path': '"$imagePath"',
        'adaptive_icon_background': '"#${backgroundColor.toRadixString(16)}"',
        'adaptive_icon_foreground': '"$foregroundImagePath"',
        'web': {
          'generate': true,
        },
      },
    };
  }

  Future<Map<String, dynamic>> _constructSplashConfig(AutomateCommandContext context) async {
    return {
      'flutter_native_splash': {
        'color': '"#${backgroundColor.toRadixString(16)}"',
        'android_12': {
          'color': '"#${backgroundColor.toRadixString(16)}"',
        }
      },
    };
  }

  Future<File> _constructAppIcon(
    AutomateCommandContext context, {
    required File foregroundImageFile,
    bool hasBackground = true,
  }) async {
    final foregroundImage = image.decodeImage(await foregroundImageFile.readAsBytes()) ??
        (throw Exception('Cannot load the foreground image!'));

    final appIconImage = _scaleImageCentered(
      source: foregroundImage,
      colorBackground: hasBackground ? _getColor(backgroundColor) : null,
      maxWidth: 1024,
      maxHeight: 1024,
      padding: padding,
    );

    final outputFile = await context.createTempFile('app_icon${hasBackground ? '_with_background' : ''}.png');

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
    image.Color? colorBackground,
    int padding = 0,
  }) {
    final scaleX = maxWidth / source.width;
    final scaleY = maxHeight / source.height;
    final scale = (scaleX * source.height > maxHeight) ? scaleY : scaleX;
    final width = (source.width * scale).round() - padding * 2;
    final height = (source.height * scale).round() - padding * 2;

    var backgroundImage = image.Image(
      width: maxWidth,
      height: maxHeight,
      numChannels: 4,
    );

    if (colorBackground != null) {
      backgroundImage = image.fill(
        backgroundImage,
        color: colorBackground,
      );
    }

    return image.compositeImage(
      backgroundImage,
      source,
      blend: image.BlendMode.alpha,
      dstX: ((maxWidth - width) / 2).round(),
      dstY: ((maxHeight - height) / 2).round(),
      dstW: width,
      dstH: height,
    );
  }
}
