import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:log/log.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:share_plus/share_plus.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class LogDebugPage extends AppPage<LogDebugRoute> {
  @override
  Widget onBuild(BuildContext context, LogDebugRoute route) {
    final logsModel = useFutureModel(() => context.getLogs());
    final logs = logsModel.getOrNull();

    return StyledPage(
      titleText: 'Logs',
      actions: [
        if (logs != null)
          ActionItem(
              titleText: 'Share',
              descriptionText: 'Share the logs with a developer.',
              iconData: Icons.share,
              color: Colors.blue,
              onPerform: (context) async {
                final box = context.findRenderObject() as RenderBox?;
                await Share.share(
                  logs.join('\n'),
                  subject: 'Logs ${DateTime.now().format()}',
                  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                );
              }),
      ],
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
}

class LogDebugRoute with IsRoute<LogDebugRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('logs');

  @override
  LogDebugRoute copy() {
    return LogDebugRoute();
  }
}
