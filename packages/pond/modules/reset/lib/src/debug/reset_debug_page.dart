import 'package:debug/debug.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class ResetDebugRoute with IsRoute<ResetDebugRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('reset');

  @override
  ResetDebugRoute copy() {
    return ResetDebugRoute();
  }
}

class ResetDebugPage with IsAppPageWrapper<ResetDebugRoute> {
  @override
  AppPage<ResetDebugRoute> get appPage => AppPage<ResetDebugRoute>().withDebugParent();

  @override
  Widget onBuild(BuildContext context, ResetDebugRoute route) {
    return StyledPage(
      titleText: 'Reset',
      body: StyledList.column.centered.scrollable.withScrollbar(
        children: [
          StyledText.xl('Are you sure you want to reset?'),
          StyledText.body(
              'This will delete Flood files from your device, which will emulate installing the app for the first time.'),
          StyledButton.strong(
            labelText: 'Reset',
            iconData: Icons.delete,
            onPressed: () async {
              await context.appPondContext.reset();
              await context.appPondContext.load();
              context.read<PondApp>().navigateHome(context);
            },
          ),
        ],
      ),
    );
  }
}
