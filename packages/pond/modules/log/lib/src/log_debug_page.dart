import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:log/log.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class LogDebugPage extends AppPage {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('logs');

  @override
  Widget build(BuildContext context) {
    final logsModel = useFutureModel(() => context.getLogs());
    return StyledPage(
      titleText: 'Logs',
      body: ModelBuilder(
        model: logsModel,
        builder: (List<String> logs) {
          return StyledList.column.withScrollbar(
            children: [
              ...logs.map<Widget>((log) {
                if (log.startsWith('[WARNING]')) {
                  return StyledText.body.withColor(Colors.orange)(log);
                }
                if (log.startsWith('[ERROR]')) {
                  return StyledText.body.error(log);
                }
                return StyledText.body(log);
              }).intersperse(StyledDivider()),
            ],
          );
        },
      ),
    );
  }

  @override
  AppPage copy() {
    return LogDebugPage();
  }
}
