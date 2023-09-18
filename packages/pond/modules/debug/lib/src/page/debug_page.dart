import 'package:debug/src/page/debug_page_component.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class DebugPage with IsAppPage<DebugRoute> {
  @override
  Widget onBuild(BuildContext context, DebugRoute route) {
    final debugPageComponents = context.appPondContext.appComponents.whereType<DebugPageComponent>().toList();
    return StyledPage(
      titleText: 'Debug',
      body: StyledList.column.centered.withScrollbar.withMinChildSize(250)(
        children: debugPageComponents
            .map((debugPageComponent) => StyledCard(
                  titleText: debugPageComponent.name,
                  bodyText: debugPageComponent.description,
                  leading: debugPageComponent.icon,
                  onPressed: () => context.push(debugPageComponent.route),
                ))
            .toList(),
      ),
    );
  }
}

class DebugRoute with IsRoute<DebugRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug');

  @override
  DebugRoute copy() {
    return DebugRoute();
  }
}
