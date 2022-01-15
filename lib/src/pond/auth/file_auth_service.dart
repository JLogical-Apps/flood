import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/json_file_data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/string_file_data_source.dart';
import 'package:jlogical_utils/src/persistence/ids/uuid_id_generator.dart';
import 'package:path/path.dart';

import 'auth_service.dart';
import 'login_failure.dart';
import 'signup_failure.dart';

class FileAuthService implements AuthService {
  final FileDataSource<String?> loggedInUserIdDataSource;
  final FileDataSource<Map<_LoginToken, String>> registeredUsersDataSource;

  final UuidIdGenerator _uuidGenerator = UuidIdGenerator();

  FileAuthService({
    required Directory parentDirectory,
  })  : loggedInUserIdDataSource = StringFileDataSource(
          file: File(join(parentDirectory.path, 'logged_in_user_token.txt')),
          fromString: (string) => string == '' ? null : string,
          toString: (string) => string ?? '',
        ),
        registeredUsersDataSource = JsonFileDataSource(
          file: File(join(parentDirectory.path, 'registered_users.json')),
          fromJson: (json) {
            Map<String, dynamic> registeredUsers = json['registeredUsers'];
            return registeredUsers.map((email, data) => MapEntry(
                  _LoginToken(
                    email: email,
                    password: data['password'],
                  ),
                  data['userId'] as String,
                ));
          },
          toJson: (registeredUsers) => {
            'registeredUsers': registeredUsers.map((loginToken, userId) => MapEntry(loginToken.email, {
                  'userId': userId,
                  'password': loginToken.password,
                }))
          },
        );

  @override
  Future<String?> getCurrentlyLoggedInUserId() async {
    return await loggedInUserIdDataSource.getData();
  }

  @override
  Future<String> login({required String email, required String password}) async {
    final loginToken = _LoginToken(email: email, password: password);

    final registeredUsers = await registeredUsersDataSource.getData() ?? {};
    final userId = registeredUsers[loginToken];
    if (userId == null) {
      throw LoginFailure.userNotFound();
    }

    await loggedInUserIdDataSource.saveData(userId);

    return userId;
  }

  @override
  Future<String> signup({required String email, required String password}) async {
    final loginToken = _LoginToken(email: email, password: password);

    final registeredUsers = await registeredUsersDataSource.getData() ?? {};
    final existingUser = registeredUsers[loginToken];
    if (existingUser != null) {
      throw SignupFailure.emailAlreadyUsed();
    }

    final userId = _uuidGenerator.getId(null);

    registeredUsers[loginToken] = userId;

    await Future.wait([
      registeredUsersDataSource.saveData(registeredUsers),
      loggedInUserIdDataSource.saveData(userId),
    ]);

    return userId;
  }

  @override
  Future<void> logout() {
    return loggedInUserIdDataSource.saveData(null);
  }
}

/// Token used to simulate logging in. Only used for local testing purposes.
class _LoginToken extends Equatable {
  final String email;
  final String password;

  const _LoginToken({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
