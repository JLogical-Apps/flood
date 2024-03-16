import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:flood_core/flood_core.dart';

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  ).adapting('user').withSecurity(RepositorySecurity(
        read: Permission.authenticated,
        create: Permission.authenticated,
        update: Permission.authenticated,
        delete: Permission.admin,
      ));
}
