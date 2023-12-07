import 'package:collection/collection.dart';
import 'package:debug/debug.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intersperse/intersperse.dart';
import 'package:log/log.dart';
import 'package:log/src/log_history_card.dart';
import 'package:log_core/log_core.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:share/share.dart';
import 'package:style/style.dart';

class LogDebugRoute with IsRoute<LogDebugRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('logs');

  @override
  LogDebugRoute copy() {
    return LogDebugRoute();
  }
}

class LogDebugPage with IsAppPageWrapper<LogDebugRoute> {
  @override
  AppPage<LogDebugRoute> get appPage => AppPage<LogDebugRoute>().withDebugParent();

  @override
  Widget onBuild(BuildContext context, LogDebugRoute route) {
    final logHistoriesModel = useFutureModel(() => context.logger.getLogHistories());

    final selectedLogHistory = useState<LogHistory?>(null);
    final displayedLogHistory = selectedLogHistory.value ?? logHistoriesModel.getOrNull()?.firstOrNull;

    final loadedLogHistoryState = useState<(DateTime, List<String>)?>(null);
    useEffect(
      () {
        () async {
          if (displayedLogHistory == null) {
            return;
          }

          loadedLogHistoryState.value = (
            await displayedLogHistory.getTimeCreated(),
            await displayedLogHistory.getLogs(),
          );
        }();
        return null;
      },
      [displayedLogHistory],
    );

    return ModelBuilder.page(
        model: logHistoriesModel,
        builder: (List<LogHistory> logHistories) {
          final (timeCreated, logs) = loadedLogHistoryState.value ?? (null, null);
          return StyledPage.refreshable(
            titleText: 'Logs',
            onRefresh: () => logHistoriesModel.load(),
            actions: [
              if (timeCreated != null)
                ActionItem(
                    titleText: 'Share',
                    descriptionText: 'Share the logs with a developer.',
                    iconData: Icons.share,
                    color: Colors.blue,
                    onPerform: (context) async {
                      await context.find<ShareAppComponent>().shareText(
                            context,
                            text: logs!.join('\n---\n'),
                          );
                    }),
            ],
            children: [
              StyledList.row.withScrollbar(
                children: logHistories
                    .mapIndexed((i, logHistory) => LogHistoryCard(
                          history: logHistory,
                          isSelected:
                              selectedLogHistory.value == null ? i == 0 : selectedLogHistory.value == logHistory,
                          onPressed: () => selectedLogHistory.value = logHistory,
                        ))
                    .toList(),
              ),
              if (logs != null)
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
        });
  }
}
