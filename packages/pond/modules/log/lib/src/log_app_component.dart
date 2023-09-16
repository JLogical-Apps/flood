import 'package:debug/debug.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:log/src/log_debug_page.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class LogAppComponent with IsAppPondComponent, IsDebugPageComponent {
  @override
  String get name => 'Logs';

  @override
  String get description => 'View the logs from the current app session';

  @override
  Widget get icon => StyledIcon(Icons.event_note_outlined);

  @override
  Route get route => LogDebugRoute();

  @override
  Map<Route, AppPage> get pages => {
        LogDebugRoute(): LogDebugPage(),
      };
}
