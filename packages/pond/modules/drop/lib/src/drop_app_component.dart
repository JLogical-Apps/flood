import 'package:debug/debug.dart';
import 'package:drop/src/debug/drop_debug_component.dart';
import 'package:drop/src/debug/drop_debug_page.dart';
import 'package:drop/src/debug/drop_debug_repository_page.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class DropAppComponent with IsAppPondComponent, IsDebugDialogComponent, IsDebugPageComponentWrapper {
  static const queriesRunField = 'queriesRun';

  @override
  List<AppPage<AppPage>> get pages => [
        DropDebugPage(),
        DropDebugRepositoryPage(),
      ];

  @override
  Widget renderDebug(BuildContext context, DebugDialogContext debugContext) {
    final queryRunToValue =
        (debugContext.data[queriesRunField] ?? <QueryRequest, FutureValue>{}) as Map<QueryRequest, FutureValue>;
    return StyledCard(
      titleText: 'Queries Run',
      children: queryRunToValue
          .mapToIterable((queryRequest, value) => StyledCard(
                title: StyledText.body.centered(queryRequest.toString()),
                body: value.when(
                  onEmpty: () => StyledText.body('N/A'),
                  onLoading: () => StyledLoadingIndicator(),
                  onLoaded: (data) => StyledText.body(data?.toString() ?? ''),
                  onError: (error, stackTrace) => StyledText.body.error(error),
                ),
              ))
          .toList(),
    );
  }

  @override
  DebugPageComponent get debugPageComponent => DropDebugComponent();
}
