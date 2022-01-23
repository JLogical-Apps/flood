import 'dart:io';

import 'package:example/pond/domain/user/user.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class UserRepository extends DefaultAdaptingRepository<UserEntity, User> {
  @override
  final Directory baseDirectory;

  String get collectionPath => 'users';

  UserRepository({required this.baseDirectory});

  @override
  UserEntity createEntity() {
    return UserEntity();
  }

  @override
  User createValueObject() {
    return User();
  }
}
