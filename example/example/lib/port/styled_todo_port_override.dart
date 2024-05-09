import 'package:example_core/features/tag/tag.dart';
import 'package:example_core/features/tag/tag_entity.dart';
import 'package:example_core/features/todo/todo.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StyledTodoPortOverride with IsStyledObjectPortOverride<Todo> {
  @override
  Widget build(Port port) {
    return HookBuilder(
      builder: (context) {
        final loggedInUserId = useLoggedInUserIdOrNull();
        return StyledObjectPortBuilder(
          port: port,
          overrides: {
            Todo.tagsField: StyledList.column(
              children: [
                StyledListPortField(
                  fieldPath: Todo.tagsField,
                  label: StyledList.row(
                    children: [
                      Expanded(child: StyledText.lg.bold.display('Tags')),
                      if (loggedInUserId != null)
                        StyledButton.strong(
                          labelText: 'Create Tag',
                          iconData: Icons.add,
                          onPressed: () async {
                            await context.showStyledDialog(StyledPortDialog(
                              titleText: 'Create New Tag',
                              port: (Tag()..ownerProperty.set(loggedInUserId)).asPort(context.corePondContext),
                              onAccept: (Tag tag) async {
                                final tagEntity = await context.dropCoreComponent.updateEntity(TagEntity()..set(tag));
                                port.addToList(path: Todo.tagsField, value: tagEntity.id!);
                              },
                            ));
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          },
        );
      },
    );
  }
}
