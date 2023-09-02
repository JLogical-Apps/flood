import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class ResetDebugPage extends AppPage<ResetDebugPage> {
  @override
  Widget build(BuildContext context) {
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

  @override
  ResetDebugPage copy() {
    return ResetDebugPage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('reset');
}
