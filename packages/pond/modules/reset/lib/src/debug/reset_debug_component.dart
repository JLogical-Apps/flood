import 'package:debug/debug.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:pond/pond.dart';
import 'package:reset/src/debug/reset_debug_page.dart';
import 'package:style/style.dart';

class ResetDebugComponent with IsDebugPageComponent {
  @override
  Route get route => ResetDebugRoute();

  @override
  String get name => 'Reset';

  @override
  String get description => 'Reset as if the app has never been installed on this device.';

  @override
  Widget get icon => StyledIcon(Icons.delete);
}
