import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example_core/features/tag/tag.dart';
import 'package:example_core/features/tag/tag_entity.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

class TagsRoute with IsRoute<TagsRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.string('tags');

  @override
  TagsRoute copy() {
    return TagsRoute();
  }
}

class TagsPage with IsAppPageWrapper<TagsRoute> {
  @override
  AppPage<TagsRoute> get appPage => AppPage<TagsRoute>().onlyIfLoggedIn();

  @override
  Widget onBuild(BuildContext context, TagsRoute route) {
    final loggedInUserId = useLoggedInUserId();
    final tagsModel = useQuery(Query.from<TagEntity>().where(Tag.ownerField).isEqualTo(loggedInUserId).all());

    return ModelBuilder.page(
      model: tagsModel,
      builder: (List<TagEntity> tagEntities) {
        return StyledPage(
          titleText: 'Tags',
          body: StyledList.column.withScrollbar(
            children: [
              StyledButton(
                labelText: 'Create New Tag',
                iconData: Icons.add,
                onPressed: () async {
                  await context.showStyledDialog(StyledPortDialog(
                    titleText: 'Create Tag',
                    port: (Tag()..ownerProperty.set(loggedInUserId)).asPort(context.corePondContext),
                    onAccept: (Tag tag) async {
                      await context.dropCoreComponent.updateEntity(TagEntity()..set(tag));
                    },
                  ));
                },
              ),
              StyledList.column.withMinChildSize(250)(
                ifEmptyText: "You've got no tags!",
                children: tagEntities
                    .map((tagEntity) => StyledCard(
                          titleText: tagEntity.value.nameProperty.value,
                          leading: StyledContainer(
                            width: 20,
                            height: 20,
                            shape: CircleBorder(),
                            color: Color(tagEntity.value.colorProperty.value),
                          ),
                          actions: ActionItem.static.entityCrudActions(context, entity: tagEntity),
                        ))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
