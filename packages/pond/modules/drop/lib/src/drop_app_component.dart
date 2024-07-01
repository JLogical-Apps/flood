import 'package:debug/debug.dart';
import 'package:drop/drop.dart';
import 'package:drop/src/debug/drop_debug_component.dart';
import 'package:drop/src/debug/drop_debug_page.dart';
import 'package:drop/src/debug/drop_debug_repository_page.dart';
import 'package:drop/src/debug/sync_debug_page.dart';
import 'package:drop/src/sync_debug_component.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class DropAppComponent with IsAppPondComponent, IsDebugDialogComponent, IsDebugPageComponentWrapper {
  static const queriesRunField = 'queriesRun';

  @override
  Map<Route, AppPage> get pages => {
        DropDebugRoute(): DropDebugPage(),
        DropDebugRepositoryRoute(): DropDebugRepositoryPage(),
        SyncDebugRoute(): SyncDebugPage(),
      };

  @override
  Future onRegister(AppPondContext context) async {
    await context.register(SyncDebugComponent());
  }

  @override
  Widget renderDebug(BuildContext context, DebugDialogContext debugContext) {
    final queryRunToValue =
        (debugContext.data[queriesRunField] ?? <QueryRequest, FutureValue>{}) as Map<QueryRequest, FutureValue>;
    return StyledCard(
      titleText: 'Queries Run',
      children: queryRunToValue
          .mapToIterable((queryRequest, value) => StyledCard(
                title: StyledText.body.centered(queryRequest.prettyPrint(context.dropCoreComponent)),
                body: value.when(
                  onEmpty: () => StyledText.body('N/A'),
                  onLoading: () => StyledLoadingIndicator(),
                  onLoaded: (data) {
                    if (data is PaginatedQueryResult<Entity>) {
                      final model = Model(loader: () => data.page.getItems());
                      return ModelBuilder(
                        model: model,
                        builder: (List<Entity> entities) {
                          return StyledText.body(
                            'Paginated(\n[${entities.map((entity) => entity.getState(context.dropCoreComponent).toString()).join(',')}],\nhasNext: ${data.page.hasNext}\n)',
                          );
                        },
                      );
                    }
                    return StyledText.body(prettyPrint(context.dropCoreComponent, data) ?? '');
                  },
                  onError: (error, stackTrace) => StyledText.body.error(error),
                ),
              ))
          .toList(),
    );
  }

  String? prettyPrint(DropCoreContext context, dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is Entity) {
      return data.getState(context).toString();
    } else if (data is List<Entity>) {
      return '[${data.map((entity) => entity.getState(context).toString()).join(',')}]';
    }
    return data.toString();
  }

  @override
  DebugPageComponent get debugPageComponent => DropDebugComponent();
}
