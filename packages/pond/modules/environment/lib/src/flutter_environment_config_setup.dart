import 'dart:io' as io;

import 'package:environment_core/environment_core.dart';
import 'package:flutter/foundation.dart';

class FlutterEnvironmentConfigSetup with IsEnvironmentConfigWrapper {
  @override
  final EnvironmentConfig environmentConfig;

  FlutterEnvironmentConfigSetup({required this.environmentConfig});

  @override
  Future<BuildType> getBuildType() async {
    if (kReleaseMode) {
      return BuildType.release;
    }

    return BuildType.regular;
  }

  @override
  Future<Platform> getPlatform() async {
    if (kIsWeb) {
      return Platform.web;
    }

    if (io.Platform.isAndroid || io.Platform.isIOS || io.Platform.isFuchsia) {
      return Platform.mobile;
    }

    if (io.Platform.isLinux || io.Platform.isMacOS || io.Platform.isWindows) {
      return Platform.desktop;
    }

    return Platform.cli;
  }
}
