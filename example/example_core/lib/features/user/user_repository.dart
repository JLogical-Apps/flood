import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  ).adapting('user').withSecurity(RepositorySecurity(
        read: Permission.authenticated,
        create: Permission.authenticated & Permission.unmodifiable(User.adminField),
        update: Permission.authenticated & Permission.unmodifiable(User.adminField),
        delete: Permission.isAdmin(userEntityType: UserEntity, adminField: User.adminField),
      ));
}
