import 'package:debug/debug.dart';
import 'package:drop/drop.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class DropDebugRepositoryRoute with IsRoute<DropDebugRepositoryRoute> {
  late final hashProperty = field<int>(name: 'hash').required();

  @override
  DropDebugRepositoryRoute copy() {
    return DropDebugRepositoryRoute();
  }

  @override
  PathDefinition get pathDefinition =>
      PathDefinition.string('_debug').string('drop').string('repository').property(hashProperty);
}

class DropDebugRepositoryPage with IsAppPageWrapper<DropDebugRepositoryRoute> {
  @override
  AppPage<DropDebugRepositoryRoute> get appPage => AppPage<DropDebugRepositoryRoute>().withDebugParent();

  @override
  Widget onBuild(BuildContext context, DropDebugRepositoryRoute route) {
    final repository = context.dropCoreComponent.repositories
        .firstWhere((repository) => repository.hashCode == route.hashProperty.value);
    final entitiesModel = useFutureModel(() => repository.executeQuery(Query.fromAll().paginate(pageSize: 50)));

    return PaginatedQueryModelBuilder.page(
      paginatedQueryModel: entitiesModel,
      builder: (List<Entity> entities, Future Function()? loadMore) {
        return StyledPage(
          titleText: repository.runtimeType.toString(),
          actions: [
            ActionItem(
              titleText: 'Re-save All Entities',
              descriptionText: 'Save all entities in this repository. Use this for re-indexing fallback values.',
              color: Colors.blue,
              iconData: Icons.save,
              onPerform: (_) async {
                final entities = await repository.executeQuery(Query.fromAll().all());
                for (final entity in entities) {
                  await repository.update(entity);
                }
                await context.showStyledMessage(StyledMessage(labelText: 'Successfully re-saved all entiites!'));
              },
            ),
          ],
          body: StyledList.column.scrollable.withScrollbar.centered.withMinChildSize(250)(
            children: [
              ...entities.map(
                (entity) => StyledCard(
                  titleText: entity.id,
                  children: entity
                      .getStateUnsafe(context.dropCoreComponent)
                      .data
                      .mapToIterable((name, value) => StyledMarkdown(
                            '`$name`: $value',
                            textAlign: WrapAlignment.start,
                          ))
                      .toList(),
                ),
              ),
              if (loadMore != null)
                StyledButton.strong(
                  labelText: 'Load More',
                  onPressed: () async {
                    await loadMore();
                  },
                ),
            ],
            ifEmptyText: 'There are no entities in this repository.',
          ),
        );
      },
    );
  }
}
