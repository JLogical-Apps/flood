import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example_core/features/todo/todo.dart';
import 'package:example_core/features/todo/todo_entity.dart';
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
          actions: [
            ActionItem.static.editEntity(
              context,
              entity: loggedInUserEntity,
              contentTypeName: 'Profile',
              description: 'Edit your profile.',
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
                    await Future.wait(todos.map((todo) => context.dropCoreComponent.update(TodoEntity()..set(todo))));
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
                ...uncompletedTodos.map((todoEntity) => StyledCard(
                      key: ValueKey(todoEntity.id),
                      titleText: todoEntity.value.nameProperty.value,
                      bodyText: todoEntity.value.descriptionProperty.value,
                      leading: StyledCheckbox(
                        value: todoEntity.value.completedProperty.value,
                        onChanged: (value) async {
                          await context.dropCoreComponent
                              .updateEntity(todoEntity, (Todo todo) => todo.completedProperty.set(value));
                        },
                      ),
                      actions: getTodoActions(context, todoEntity: todoEntity),
                    )),
                if (uncompletedTodos.isNotEmpty && completedTodos.isNotEmpty) ...[
                  StyledDivider(),
                  StyledText.xl.display.bold('Completed'),
                ],
                ...completedTodos.map((todoEntity) => StyledCard(
                      key: ValueKey(todoEntity.id),
                      titleText: todoEntity.value.nameProperty.value,
                      bodyText: todoEntity.value.descriptionProperty.value,
                      leading: StyledCheckbox(
                        value: todoEntity.value.completedProperty.value,
                        onChanged: (value) async {
                          await context.dropCoreComponent
                              .updateEntity(todoEntity, (Todo todo) => todo.completedProperty.set(value));
                        },
                      ),
                      actions: getTodoActions(context, todoEntity: todoEntity),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  List<ActionItem> getTodoActions(BuildContext context, {required TodoEntity todoEntity}) {
    return ActionItem.static.entityCrudActions(
      context,
      entity: todoEntity,
      duplicator: (Todo todo) => todo..nameProperty.update((name) => '$name - Copy'),
    );
  }
}
