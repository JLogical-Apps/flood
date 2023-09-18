import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class ResetDebugPage with IsAppPage<ResetDebugRoute> {
  @override
  Widget onBuild(BuildContext context, ResetDebugRoute route) {
    return StyledPage(
      titleText: 'Reset',
      body: StyledList.column.centered.scrollable.withScrollbar(
        children: [
          StyledText.h5('Are you sure you want to reset?'),
          StyledButton.strong(
            labelText: 'Reset',
            iconData: Icons.delete,
            onPressed: () async {
              await context.corePondContext.reset();
              context.read<PondApp>().navigateHome(context);
            },
          ),
        ],
      ),
    );
  }
}

class ResetDebugRoute with IsRoute<ResetDebugRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('reset');

  @override
  ResetDebugRoute copy() {
    return ResetDebugRoute();
  }
}
