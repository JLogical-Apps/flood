import 'package:debug/src/page/debug_page_component.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class DebugPage extends AppPage {
  @override
  Widget build(BuildContext context) {
    final debugPageComponents = context.appPondContext.appComponents.whereType<DebugPageComponent>().toList();
    return StyledPage(
      titleText: 'Debug',
      body: StyledList.column.withScrollbar(
          children: debugPageComponents.map((debugPageComponent) => StyledText.body(debugPageComponent.name)).toList()),
    );
  }

  @override
  AppPage copy() {
    return DebugPage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug');
}
