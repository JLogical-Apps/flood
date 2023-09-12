import 'package:drop/drop.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class DropDebugRepositoryPage extends AppPage<DropDebugRepositoryPage> {
  late final hashProperty = field<int>(name: 'hash').required();

  @override
  Widget build(BuildContext context) {
    final repository =
        context.dropCoreComponent.repositories.firstWhere((repository) => repository.hashCode == hashProperty.value);
    final entitiesModel = useFutureModel(() => repository.executeQuery(Query.fromAll().paginate(pageSize: 50)));

    return PaginatedQueryModelBuilder(
      paginatedQueryModel: entitiesModel,
      builder: (List<Entity> entities, Future Function()? loadMore) {
        return StyledPage(
          titleText: repository.runtimeType.toString(),
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

  @override
  DropDebugRepositoryPage copy() {
    return DropDebugRepositoryPage();
  }

  @override
  PathDefinition get pathDefinition =>
      PathDefinition.string('_debug').string('drop').string('repository').property(hashProperty);
}