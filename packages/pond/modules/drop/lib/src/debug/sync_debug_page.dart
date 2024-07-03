import 'package:drop/drop.dart';
import 'package:flutter/material.dart';
import 'package:log/log.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:runtime_type/type.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class SyncDebugRoute with IsRoute<SyncDebugRoute> {
  @override
  SyncDebugRoute copy() {
    return SyncDebugRoute();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('_debug').string('sync');
}

class SyncDebugPage with IsAppPageWrapper<SyncDebugRoute> {
  @override
  AppPage<SyncDebugRoute> get appPage => AppPage<SyncDebugRoute>();

  @override
  Widget onBuild(BuildContext context, SyncDebugRoute route) {
    final syncActionsModel =
        useQuery(Query.from<SyncActionEntity>().orderByAscending(CreationTimeProperty.field).all());
    final syncState = useSyncState();
    return StyledPage(
      titleText: 'Sync',
      actions: [
        ActionItem(
          titleText: 'Reset',
          descriptionText: 'Reset the sync module to its original state.',
          color: Colors.red,
          iconData: Icons.restart_alt,
          onPerform: (_) async {
            final corePondContext = context.corePondContext;
            await corePondContext.syncCoreComponent.reset(corePondContext);
            await corePondContext.syncCoreComponent.load(corePondContext);

            context.warpToLocation('/');
          },
        ),
      ],
      body: StyledList.column.centered.withScrollbar(
        children: [
          SyncIndicator(),
          StyledButton.strong(
            labelText: 'Force Publish',
            onPressed: syncState == SyncState.syncing
                ? null
                : () async {
                    try {
                      await context.corePondContext.syncCoreComponent.publish();
                    } catch (e, stackTrace) {
                      context.logError(e, stackTrace);
                      context.showStyledMessage(StyledMessage.error(labelText: 'Error publishing changes: $e'));
                    }
                  },
          ),
          StyledCard(
            titleText: 'Pending Publishes',
            children: [
              ModelBuilder(
                model: syncActionsModel,
                builder: (List<SyncActionEntity> actionEntities) {
                  return StyledList.column(
                    ifEmptyText: 'No pending publishes!',
                    children: actionEntities
                        .map((actionEntity) => StyledCard(
                              titleText:
                                  context.dropCoreComponent.getRuntimeTypeRuntime(actionEntity.value.runtimeType).name,
                              bodyText: 'Created ${actionEntity.value.timeCreated.format()}',
                              actions: [ActionItem.static.deleteEntity(context, entity: actionEntity)],
                              children: [
                                StyledText.body(actionEntity.value.getState(context.dropCoreComponent).data.toString())
                              ],
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
