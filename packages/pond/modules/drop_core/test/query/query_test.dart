import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';

void main() {
  test('query all', () async {
    final repository = Repository.memory().forType<UserEntity, User>(UserEntity.new, User.new);

    final users = [
      User()
        ..nameProperty.value = 'Jake'
        ..emailProperty.value = 'jake@jake.com',
      User()
        ..nameProperty.value = 'John'
        ..emailProperty.value = 'john@doe.com',
    ];

    CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent())
      ..register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final allUserEntities = await repository.executeQuery(Query.from<UserEntity>().all());
    expect(allUserEntities.map((entity) => entity.value).toList(), users);

    final allUserStates = await repository.executeQuery(Query.from<UserEntity>().allStates());
    expect(allUserStates.map((state) => state.data), users.map((user) => user.state.data).toList());
  });
}

class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name');
  late final emailProperty = field<String>(name: 'email');

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty, emailProperty];
}

class UserEntity extends Entity<User> {}
