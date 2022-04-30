import 'dart:io';

import 'package:image/image.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

import '../../automation/automation_context.dart';
import '../../automation/automation_module.dart';
import '../../automation/automations_provider.dart';
import '../build/building_automation_module.dart';

class NativeSplashAutomationModule extends AutomationModule implements BuildingAutomationModule {
  final File imageFile;
  final int backgroundColor;

  final int imageSize;

  String get name => 'Native Splash';

  NativeSplashAutomationModule({
    required this.imageFile,
    this.backgroundColor: 0xffffff,
    this.imageSize: 1,
  }) {
    registerAutomation(
      name: 'native_splash',
      description: 'Sets the native splash screen of the app.',
      action: _setNativeSplash,
    );
  }

  @override
  Future<void> onBuild(AutomationContext context) async {
    if (context.isClean) {
      await _setNativeSplash(context);
    }
  }

  Future<void> _setNativeSplash(AutomationContext context) async {
    if (!await context.ensurePackageRegistered('flutter_native_splash', isDevDependency: true)) {
      context.error(
          "You don't have `flutter_native_splash` installed as a dev_dependency. It is needed in order to generate the app icon.");
      return;
    }

    final configurationFile = cacheDirectory - 'flutter_native_splash.yaml';
    context.print('Saving configuration into `${configurationFile.relativePath}`');
    await FileDataSource(file: configurationFile).mapYaml().saveData(await _constructConfig());

    context.run('flutter pub run flutter_native_splash:create --path="${configurationFile.relativePath}"');
  }

  Future<Map<String, dynamic>> _constructConfig() async => {
        'flutter_native_splash': {
          'color': '#${backgroundColor.toRadixString(16)}',
          'image': (await _constructAppIcon()).relativePath,
        },
      };

  Future<File> _constructAppIcon() async {
    final foregroundImage =
        decodeImage(await imageFile.readAsBytes()) ?? (throw Exception('Cannot load the foreground image!'));

    final imageWidth = foregroundImage.width * imageSize;
    final imageHeight = foregroundImage.height * imageSize;
    final image = Image(imageWidth, imageHeight);

    drawImage(image, foregroundImage, dstW: imageWidth, dstH: imageHeight);

    final outputFile = cacheDirectory - 'splash_app_icon.png';
    await outputFile.ensureCreated();

    await outputFile.writeAsBytes(encodePng(image));

    return outputFile;
  }
}
