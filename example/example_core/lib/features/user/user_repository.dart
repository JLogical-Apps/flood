import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:example_core/features/user/user_token.dart';
import 'package:flood_core/flood_core.dart';

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  )
      .adapting('user')
      .withSecurity(RepositorySecurity(
        read: Permission.admin | Permission.equals(PermissionField.entityId, PermissionField.loggedInUserId),
        create: Permission.admin | Permission.equals(PermissionField.entityId, PermissionField.loggedInUserId),
        update: Permission.admin | Permission.equals(PermissionField.entityId, PermissionField.loggedInUserId),
        delete: Permission.admin,
      ))
      .withEmbeddedType<UserToken>(UserToken.new, valueObjectTypeName: 'UserToken');
}
