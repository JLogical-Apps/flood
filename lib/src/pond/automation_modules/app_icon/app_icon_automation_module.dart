import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:image/image.dart';
import 'package:jlogical_utils/src/pond/automation_modules/environment/environment_listening_automation_module.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../persistence/export_core.dart';
import '../../automation/automation_context.dart';
import '../../automation/automation_module.dart';
import '../../automation/automations_provider.dart';
import '../../modules/environment/environment.dart';
import '../build/building_automation_module.dart';
import 'app_icon_banner.dart';

class AppIconAutomationModule extends AutomationModule
    implements BuildingAutomationModule, EnvironmentListeningAutomationModule {
  final File appIconForegroundFile;
  final int backgroundColor;
  final List<AppIconBanner> banners;

  @override
  String get name => 'App Icon';

  AppIconAutomationModule({
    required this.appIconForegroundFile,
    this.backgroundColor: 0xffffff,
    this.banners: const [],
  });

  @override
  List<Command> get commands => [
        SimpleCommand(
          name: 'app_icon',
          displayName: 'Set App Icon',
          description: 'Set the app icon of the app.',
          category: 'App Icon',
          runner: (args) async {
            await _setAppIcon();
          },
        ),
      ];

  @override
  Future<void> onBuild(bool isClean) async {
    if (isClean) {
      await _setAppIcon();
    }
  }

  @override
  Future<void> onEnvironmentChanged(
    Environment? oldEnvironment,
    Environment newEnvironment,
  ) async {
    await _setAppIcon();
  }

  Future<void> _setAppIcon() async {
    if (!await context.ensurePackageRegistered('flutter_launcher_icons', isDevDependency: true)) {
      context.error(
          "You don't have `flutter_launcher_icons` installed as a dev_dependency. It is needed in order to generate the app icon.");
      return;
    }

    // Sometimes the AppIcon.appiconset folder isn't created causing flutter_launcher_icons to crash.
    final iosAssetsFolder = Directory.current / 'ios' / 'Runner' / 'Assets.xcassets' / 'AppIcon.appiconset';
    iosAssetsFolder.ensureCreated();

    final configurationFile = cacheDirectory - 'flutter_launcher_icons.yaml';
    context.print('Saving configuration into `${configurationFile.relativePath}`');
    await FileDataSource(file: configurationFile).mapYaml().saveData(await _constructConfig());

    context.run('flutter pub run flutter_launcher_icons:main -f "${configurationFile.relativePath}"');
  }

  Future<Map<String, dynamic>> _constructConfig() async {
    var foregroundFile = appIconForegroundFile;

    final environment = await context.getEnvironmentOrNull(shouldAskIfNoArg: false);
    final banner = environment.mapIfNonNull((env) => banners.firstWhereOrNull((banner) => banner.environment == env));
    if (banner != null) {
      foregroundFile = await _constructForegroundImage(banner: banner);
    }

    return {
      'flutter_icons': {
        'android': true,
        'ios': true,
        'remove_alpha_ios': true,
        'image_path': (await _constructAppIcon(context, foregroundImageFile: foregroundFile)).relativePath,
        'adaptive_icon_background': '#${backgroundColor.toRadixString(16)}',
        'adaptive_icon_foreground': foregroundFile.relativePath,
      },
    };
  }

  Future<File> _constructAppIcon(AutomationContext context, {required File foregroundImageFile}) async {
    final foregroundImage =
        decodeImage(await foregroundImageFile.readAsBytes()) ?? (throw Exception('Cannot load the foreground image!'));
    final image = Image(foregroundImage.width, foregroundImage.height);

    fill(image, _getColor(backgroundColor));
    drawImage(image, foregroundImage);

    final outputFile = cacheDirectory - 'app_icon.png';
    await outputFile.ensureCreated();

    await outputFile.writeAsBytes(encodePng(image));

    return outputFile;
  }

  Future<File> _constructForegroundImage({required AppIconBanner banner}) async {
    var foregroundImage = decodeImage(await appIconForegroundFile.readAsBytes()) ??
        (throw Exception('Cannot load the foreground image!'));
    foregroundImage = copyResizeCropSquare(foregroundImage, foregroundImage.width);

    final bannerLength = foregroundImage.width * (sqrt(2) / 2);
    final bannerWidth = foregroundImage.width / (4 * sqrt(2));
    var bannerImage = Image(bannerLength.round(), bannerWidth.round());

    fillRect(bannerImage, 0, 0, bannerImage.width, bannerImage.height, _getColor(banner.color));
    drawStringCentered(bannerImage, roboto_72, banner.text);

    bannerImage = copyRotate(bannerImage, 45);

    final delta = (bannerWidth * (sqrt(2) / 2)).round();
    drawImage(foregroundImage, bannerImage, dstX: foregroundImage.width - bannerImage.width + delta, dstY: -delta);

    final outputFile = cacheDirectory - 'foreground_app_icon.png';
    await outputFile.ensureCreated();

    await outputFile.writeAsBytes(encodePng(foregroundImage));

    return outputFile;
  }

  int _getColor(int rgb) => Color.fromRgb((rgb & 0xff0000) >>> 16, (rgb & 0x00ff00) >>> 8, rgb & 0x0000ff);
}
