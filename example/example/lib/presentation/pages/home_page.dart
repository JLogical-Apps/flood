import 'package:example/presentation/components/todo_entity_card.dart';
import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/tags_page.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example_core/features/todo/todo.dart';
import 'package:example_core/features/todo/todo_entity.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

class HomeRoute with IsRoute<HomeRoute> {
  @override
  PathDefinition get pathDefinition => PathDefinition.home;

  @override
  HomeRoute copy() {
    return HomeRoute();
  }
}

class HomePage with IsAppPageWrapper<HomeRoute> {
  @override
  AppPage<HomeRoute> get appPage => AppPage<HomeRoute>().onlyIfLoggedIn();

  @override
  Widget onBuild(BuildContext context, HomeRoute route) {
    final loggedInUserId = useLoggedInUserIdOrNull();
    if (loggedInUserId == null) {
      return StyledLoadingPage();
    }

    final loggedInUserModel = useEntity<UserEntity>(loggedInUserId);
    final todosModel = useQuery(Query.from<TodoEntity>().where(Todo.userField).isEqualTo(loggedInUserId).all());

    return ModelBuilder.page(
      model: Model.union([loggedInUserModel, todosModel]),
      builder: (List values) {
        final [UserEntity loggedInUserEntity, List<TodoEntity> todoEntities] = values;
        final uncompletedTodos = todoEntities.where((todoEntity) => !todoEntity.value.completedProperty.value).toList();
        final completedTodos = todoEntities.where((todoEntity) => todoEntity.value.completedProperty.value).toList();

        return StyledPage(
          titleText: 'Todos',
          actionWidgets: [
            profileButton(
              context,
              user: loggedInUserEntity.value,
              actions: [
                ActionItem.static.editEntity(
                  context,
                  entity: loggedInUserEntity,
                  contentTypeName: 'Profile',
                  description: 'Edit your profile.',
                ),
                ActionItem.static.duplicateEntity(
                  context,
                  entity: loggedInUserEntity,
                  contentTypeName: 'Duplicate',
                  description: 'Duplicate your profile.',
                ),
                ActionItem(
                  titleText: 'Manage Tags',
                  descriptionText: 'Manage your tags.',
                  color: Colors.blue,
                  iconData: Icons.tag,
                  onPerform: (_) {
                    context.push(TagsRoute());
                  },
                ),
                ActionItem(
                  titleText: 'Import',
                  color: Colors.blue,
                  iconData: Icons.download,
                  descriptionText: 'Import a csv of todos',
                  onPerform: (context) async {
                    await context.showStyledDialog(StyledPortDialog(
                      port: Port.of({
                        'file': PortField.file().withDisplayName('CSV File').withAllowedFileTypes(['csv']).required(),
                      }).map((values, port) => values['file'] as CrossFile),
                      titleText: 'Import Todos',
                      onAccept: (file) async {
                        final csv = await DataSource.static.crossFile(file).mapCsv(hasHeaderRow: true).get();
                        final todos = csv
                            .map((row) => Todo()
                              ..nameProperty.set(row[0])
                              ..descriptionProperty.set(row[1])
                              ..userProperty.set(loggedInUserId))
                            .toList();
                        await Future.wait(
                            todos.map((todo) => context.dropCoreComponent.update(TodoEntity()..set(todo))));
                      },
                    ));
                  },
                ),
                ActionItem(
                  titleText: 'Logout',
                  color: Colors.red,
                  descriptionText: 'Log out of your account.',
                  iconData: Icons.logout,
                  onPerform: (context) async {
                    await context.authCoreComponent.logout();
                    await context.pushReplacement(LoginRoute());
                  },
                ),
              ],
            ),
          ],
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: StyledList.column.withScrollbar.centered(
              children: [
                StyledButton(
                  labelText: 'Create Todo',
                  iconData: Icons.add,
                  onPressed: () => context.showStyledDialog(StyledPortDialog(
                    titleText: 'Create Todo',
                    port: (Todo()..userProperty.set(loggedInUserId)).asPort(context.corePondContext),
                    onAccept: (Todo todo) async {
                      final todoEntity = TodoEntity()..set(todo);
                      await context.dropCoreComponent.update(todoEntity);
                    },
                  )),
                ),
                ...uncompletedTodos.map((todoEntity) => TodoEntityCard(
                      key: ValueKey(todoEntity.id),
                      todoEntity: todoEntity,
                    )),
                if (uncompletedTodos.isNotEmpty && completedTodos.isNotEmpty) ...[
                  StyledDivider(),
                  StyledText.xl.display.bold('Completed'),
                ],
                ...completedTodos.map((todoEntity) => TodoEntityCard(
                      key: ValueKey(todoEntity.id),
                      todoEntity: todoEntity,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget profileButton(BuildContext context, {required User user, required List<ActionItem> actions}) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: StyledContainer(
        shape: CircleBorder(),
        onPressed: () async {
          await context.showStyledDialog(StyledDialog.actionList(context: context, actions: actions));
        },
        child: user.profilePictureProperty.value != null
            ? StyledAssetProperty(
                assetProperty: user.profilePictureProperty.value!,
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              )
            : Padding(
                padding: EdgeInsets.all(5),
                child: StyledIcon(
                  Icons.person,
                  size: 25,
                ),
              ),
      ),
    );
  }
}
