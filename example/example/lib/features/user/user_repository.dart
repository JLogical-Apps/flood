import 'package:example/features/user/user.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.memory().forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  );
}
