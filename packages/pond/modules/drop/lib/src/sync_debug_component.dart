import 'package:debug/debug.dart';
import 'package:drop/src/debug/sync_debug_page.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class SyncDebugComponent with IsAppPondComponent, IsDebugPageComponent {
  @override
  String get name => 'Sync';

  @override
  String get description => 'View the Sync Queue.';

  @override
  Widget get icon => StyledIcon(Icons.cloud);

  @override
  Route get route => SyncDebugRoute();
}
