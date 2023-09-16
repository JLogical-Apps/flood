import 'package:debug/debug.dart';
import 'package:device_files/src/device_files_debug_page.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class DeviceFilesAppComponent with IsAppPondComponent, IsDebugPageComponent {
  @override
  String get name => 'Device Files';

  @override
  String get description => 'View the app files of the current device.';

  @override
  Widget get icon => StyledIcon(Icons.file_copy);

  @override
  Route get route => DeviceFilesDebugRoute();

  @override
  Map<Route, AppPage> get pages => {
        DeviceFilesDebugRoute(): DeviceFilesDebugPage(),
      };
}
