import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('reference property', () async {
    final userRepository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();
    final contentRepository = Repository.forType<ContentEntity, Content>(
      ContentEntity.new,
      Content.new,
      entityTypeName: 'ContentEntity',
      valueObjectTypeName: 'Content',
    ).memory();

    final dropCoreComponent = DropCoreComponent();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(dropCoreComponent);
    await context.register(userRepository);
    await context.register(contentRepository);

    final userEntity = UserEntity()..value = (User()..nameProperty.set('John Doe'));
    final newState = await userRepository.update(userEntity);

    final contentEntity = ContentEntity()..value = (Content()..ownerProperty.set(newState.id));
    await contentRepository.update(contentEntity);

    final queriedContentEntity = await contentRepository.executeQuery(Query.from<ContentEntity>().first());
    final queriedContent = queriedContentEntity.value;
    expect(queriedContent.ownerProperty.value, newState.id);

    final loadedUserEntity = await queriedContent.ownerProperty.load(dropCoreComponent);
    expect(loadedUserEntity!.id, newState.id);
  });
}

class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name');

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

class UserEntity extends Entity<User> {}

class Content extends ValueObject {
  late final ownerProperty = reference<UserEntity>(name: 'owner');

  @override
  List<ValueObjectBehavior> get behaviors => [ownerProperty];
}

class ContentEntity extends Entity<Content> {}
