import 'package:example_core/features/user/user.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.adapting('user')
      .forType<UserEntity, User>(
        UserEntity.new,
        User.new,
        entityTypeName: 'UserEntity',
        valueObjectTypeName: 'User',
      )
      .withSecurity(RepositorySecurity.authenticated()
          .copyWith(delete: Permission.isAdmin(userEntityType: UserEntity, adminField: User.adminField)));
}
