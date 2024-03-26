import 'package:example_core/features/todo/todo.dart';
import 'package:example_core/features/todo/todo_entity.dart';
import 'package:flood_core/flood_core.dart';

class TodoRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<TodoEntity, Todo>(
    TodoEntity.new,
    Todo.new,
    entityTypeName: 'TodoEntity',
    valueObjectTypeName: 'Todo',
  ).adapting('todo').withSecurity(RepositorySecurity.all(
        Permission.admin |
            Permission.equals(PermissionField.propertyName(Todo.userField), PermissionField.loggedInUserId),
      ));
}
