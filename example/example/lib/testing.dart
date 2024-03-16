import 'package:example_core/features/todo/todo.dart';
import 'package:example_core/features/todo/todo_entity.dart';
import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:flood/flood.dart';

Future<void> setupTesting(CorePondContext corePondContext) async {
  final authComponent = corePondContext.locate<AuthCoreComponent>();
  final dropComponent = corePondContext.locate<DropCoreComponent>();

  final account = await authComponent.signup(AuthCredentials.email(email: 'test@test.com', password: 'password'));

  final userEntity = await dropComponent.updateEntity(
    UserEntity()..id = account.accountId,
    (User user) => user
      ..nameProperty.set('John Doe')
      ..emailProperty.set('test@test.com'),
  );

  final todos = [
    Todo()
      ..nameProperty.set('Take out trash')
      ..userProperty.set(userEntity.id!),
    Todo()
      ..nameProperty.set('Call mom')
      ..descriptionProperty.set('Talk to her about the new cat!')
      ..userProperty.set(userEntity.id!),
    Todo()
      ..nameProperty.set('Read your book')
      ..descriptionProperty.set('Read 10 pages a day.')
      ..userProperty.set(userEntity.id!),
    Todo()
      ..nameProperty.set('Get milk')
      ..userProperty.set(userEntity.id!),
    Todo()
      ..nameProperty.set('Take the dogs to the vet')
      ..completedProperty.set(true)
      ..userProperty.set(userEntity.id!),
  ];

  await Future.wait(todos.map((todo) => dropComponent.update(TodoEntity()..set(todo))));
}
