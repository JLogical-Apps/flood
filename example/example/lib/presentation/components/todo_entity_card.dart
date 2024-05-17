import 'package:example/presentation/components/tag_chip.dart';
import 'package:example_core/features/tag/tag_entity.dart';
import 'package:example_core/features/todo/todo.dart';
import 'package:example_core/features/todo/todo_entity.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

class TodoEntityCard extends StatelessWidget {
  final TodoEntity todoEntity;

  const TodoEntityCard({super.key, required this.todoEntity});

  @override
  Widget build(BuildContext context) {
    return StyledCard(
      titleText: todoEntity.value.nameProperty.value,
      body: StyledList.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (todoEntity.value.descriptionProperty.value != null)
            StyledText.body(todoEntity.value.descriptionProperty.value!),
          if (todoEntity.value.tagsProperty.value.isNotEmpty)
            StyledList.row.wrap(
              children: todoEntity.value.tagsProperty.value
                  .map((tag) => ReferenceBuilder<TagEntity>(
                        id: tag,
                        builder: (TagEntity? tagEntity) =>
                            tagEntity == null ? Container() : TagChip(tag: tagEntity.value),
                      ))
                  .toList(),
            ),
          if (todoEntity.value.assetsProperty.value.isNotEmpty)
            StyledList.row.withScrollbar(
              children: todoEntity.value.assetsProperty.value
                  .map((asset) => StyledContainer.subtle(
                        onPressed: () {},
                        child: AssetReferenceBuilder.buildAssetReference(
                          asset,
                          height: 100,
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
      leading: StyledCheckbox(
        value: todoEntity.value.completedProperty.value,
        onChanged: (value) async {
          await context.dropCoreComponent.updateEntity(todoEntity, (Todo todo) => todo.completedProperty.set(value));
        },
      ),
      actions: ActionItem.static.entityCrudActions(
        context,
        entity: todoEntity,
        duplicator: (Todo todo) => todo..nameProperty.update((name) => '$name - Copy'),
      ),
    );
  }
}
