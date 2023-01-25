import 'package:debug_dialog/debug_dialog.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class DropAppComponent with IsAppPondComponent, IsDebugDialogComponent {
  static const queriesRunField = 'queriesRun';

  @override
  Widget render(BuildContext context, DebugDialogContext debugContext) {
    final queriesRun = (debugContext.data[queriesRunField] ?? <QueryRequest>[]) as List<QueryRequest>;
    return StyledList.column(
      children: [
        StyledText.h6('Queries Run: '),
        ...queriesRun.map((queryRequest) => StyledText.body(queryRequest.toString())).toList(),
      ],
    );
  }
}
