import 'package:debug/debug.dart';
import 'package:drop/src/debug/drop_debug_page.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class DropDebugComponent with IsDebugPageComponent {
  @override
  AppPage<AppPage> get appPage => DropDebugPage();

  @override
  String get name => 'Drop';

  @override
  String get description => 'Inspect the drop repositories.';

  @override
  Widget get icon => StyledIcon(Icons.search);
}
