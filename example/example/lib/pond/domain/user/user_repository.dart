import 'package:example/pond/domain/user/user.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LocalUserRepository extends EntityRepository
    with
        WithMonoEntityRepository<UserEntity>,
        WithLocalEntityRepository,
        WithIdGenerator,
        WithDomainRegistrationsProvider<User, UserEntity>
    implements RegistrationsProvider {
  @override
  UserEntity createEntity(User initialValue) {
    return UserEntity(initialValue: initialValue);
  }

  @override
  User createValueObject() {
    return User();
  }
}
