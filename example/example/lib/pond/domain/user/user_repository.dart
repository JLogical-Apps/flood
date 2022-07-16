import 'package:example/pond/domain/user/user.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class UserRepository extends DefaultAdaptingRepository<UserEntity, User> {
  @override
  String get dataPath => 'users';

  @override
  UserEntity createEntity() {
    return UserEntity();
  }

  @override
  User createValueObject() {
    return User();
  }

  @override
  EntityRepository getFirestoreRepository() {
    return super.getFirestoreRepository().asSyncingRepository(localRepository: getFileRepository());
  }
}
