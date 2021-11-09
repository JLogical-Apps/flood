import 'package:jlogical_utils/src/pond/record/entity.dart';

import 'user.dart';

class UserEntity extends Entity<User> {
  UserEntity({required User initialUser}) : super(initialValue: initialUser);
}
