import 'package:debug_dialog/debug_dialog.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';

class DropAppComponent with IsAppPondComponent, IsDebugDialogComponent {
  static const queriesRunField = 'queriesRun';

  @override
  Widget render(BuildContext context, DebugDialogContext debugContext) {
    final queriesRun = (debugContext.data[queriesRunField] ?? <QueryRequest>[]) as List<QueryRequest>;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Queries Run: ',
            style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
          ),
          ...queriesRun
              .map((queryRequest) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      queryRequest.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
