import 'package:example/presentation/components/style_switcher.dart';
import 'package:example/presentation/components/todo_entity_card.dart';
import 'package:example/presentation/pages/auth/login_page.dart';
import 'package:example/presentation/pages/tags_page.dart';
import 'package:example/presentation/utils/redirect_utils.dart';
import 'package:example_core/components/testing_utility_component.dart';
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
    final todosModel = useQuery(Query.from<TodoEntity>()
        .where(Todo.userField)
        .isEqualTo(loggedInUserId)
        .orderByAscending(CreationTimeProperty.field)
        .paginate());

    return ModelBuilder.page(
      model: loggedInUserModel,
      builder: (UserEntity loggedInUserEntity) {
        return StyledPage(
          titleText: 'Welcome',
          actionWidgets: [
            if (context.corePondContext.testingComponent.useSyncing) ...[
              SyncIndicator(),
              SizedBox(width: 5),
            ],
            StyleSwitcher(),
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
          body: PaginatedQueryModelBuilder(
              paginatedQueryModel: todosModel,
              builder: (List<TodoEntity> todoEntities, loadMore) {
                final uncompletedTodos =
                    todoEntities.where((todoEntity) => !todoEntity.value.completedProperty.value).toList();
                final completedTodos =
                    todoEntities.where((todoEntity) => todoEntity.value.completedProperty.value).toList();

                return StyledList.column.withScrollbar(
                  children: [
                    StyledSection(
                      titleText: 'Todos',
                      trailing: StyledButton(
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
                      children: [
                        ...uncompletedTodos.map((todoEntity) => TodoEntityCard(
                              key: ValueKey(todoEntity.id),
                              todoEntity: todoEntity,
                            )),
                        if (uncompletedTodos.isNotEmpty && completedTodos.isNotEmpty) StyledDivider(),
                        if (completedTodos.isNotEmpty)
                          StyledSection(
                            titleText: 'Completed',
                            children: completedTodos
                                .map((todoEntity) => TodoEntityCard(
                                      key: ValueKey(todoEntity.id),
                                      todoEntity: todoEntity,
                                    ))
                                .toList(),
                          ),
                        if (loadMore != null)
                          StyledButton(
                            labelText: 'Load More',
                            onPressed: loadMore,
                          ),
                      ],
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  Widget profileButton(BuildContext context, {required User user, required List<ActionItem> actions}) {
    return StyledButton(
      onPressed: () async {
        await context.showStyledDialog(StyledDialog.actionList(context: context, actions: actions));
      },
      background: user.profilePictureProperty.value != null
          ? StyledAssetProperty(
              assetProperty: user.profilePictureProperty.value!,
              fit: BoxFit.cover,
            )
          : null,
      icon: user.profilePictureProperty.value == null ? StyledIcon(Icons.person) : null,
    );
  }
}
