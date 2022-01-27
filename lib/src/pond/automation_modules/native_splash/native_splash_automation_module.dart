import 'dart:io';

import 'package:jlogical_utils/automation.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

class NativeSplashAutomationModule extends AutomationModule {
  final File imageFile;
  final int backgroundColor;

  String get name => 'Native Splash';

  NativeSplashAutomationModule({required this.imageFile, this.backgroundColor: 0xffffff}) {
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

    final configurationFile = automateOutputDirectory - 'flutter_native_splash.yaml';
    context.print('Saving configuration into `${configurationFile.relativePath}`');
    await FileDataSource(file: configurationFile).mapYaml().saveData(await _constructConfig());

    context.run('flutter pub run flutter_native_splash:create --path=${configurationFile.relativePath}');
  }

  Future<Map<String, dynamic>> _constructConfig() async => {
        'flutter_native_splash': {
          'color': '#${backgroundColor.toRadixString(16)}',
          'image': imageFile.relativePath,
        },
      };
}
