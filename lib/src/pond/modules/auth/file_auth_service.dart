import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/persistence/data_source/data_source.dart';
import 'package:jlogical_utils/src/persistence/data_source/file_data_source.dart';
import 'package:jlogical_utils/src/persistence/ids/uuid_id_generator.dart';
import 'package:jlogical_utils/src/utils/file_extensions.dart';

import 'auth_service.dart';
import 'login_failure.dart';
import 'signup_failure.dart';

class FileAuthService extends AuthService {
  final DataSource<String> loggedInUserIdDataSource;
  final DataSource<Map<_LoginToken, String>> registeredUsersDataSource;

  final UuidIdGenerator _uuidGenerator = UuidIdGenerator();

  FileAuthService({
    required Directory parentDirectory,
  })  : loggedInUserIdDataSource = FileDataSource(file: parentDirectory - 'logged_in_user_token.txt').map<String>(
          onSave: (string) => string,
          onLoad: (string) => string == '' ? null : string,
        ),
        registeredUsersDataSource =
            FileDataSource(file: parentDirectory - 'registered_users.json').mapJson().map<Map<_LoginToken, String>>(
                  onSave: (registeredUsers) => {
                    'registeredUsers': registeredUsers.map((loginToken, userId) => MapEntry(loginToken.email, {
                          'userId': userId,
                          'password': loginToken.password,
                        }))
                  },
                  onLoad: (json) {
                    if (json == null) {
                      return {};
                    }

                    Map<String, dynamic> registeredUsers = json['registeredUsers'];
                    return registeredUsers.map((email, data) => MapEntry(
                          _LoginToken(
                            email: email,
                            password: data['password'],
                          ),
                          data['userId'] as String,
                        ));
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
    return loggedInUserIdDataSource.delete();
  }

  @override
  Future<void> onReset() async {
    await super.onReset();
    await loggedInUserIdDataSource.delete();
    await registeredUsersDataSource.delete();
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
