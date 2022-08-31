import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../../../persistence/export_core.dart';
import 'auth_service.dart';
import 'login_failure.dart';
import 'signup_failure.dart';

class FileAuthService extends AuthService {
  final DataSource<String> loggedInUserIdDataSource;
  final DataSource<Map<_LoginToken, String>> registeredUsersDataSource;

  final UuidIdGenerator _uuidGenerator = UuidIdGenerator();

  FileAuthService({
    required String authDirectory,
  })  : loggedInUserIdDataSource =
            FileDataSource(file: AppContext.global.supportDirectory / authDirectory - 'logged_in_user_token.txt')
                .map<String>(
          onSave: (string) => string,
          onLoad: (string) => string == '' ? null : string,
        ),
        registeredUsersDataSource =
            FileDataSource(file: AppContext.global.supportDirectory / authDirectory - 'registered_users.json')
                .mapJson()
                .map<Map<_LoginToken, String>>(
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
  Future<void> onReset(AppContext context) async {
    await super.onReset(context);
    await loggedInUserIdDataSource.delete();
    await registeredUsersDataSource.delete();
  }

  @override
  Future<void> deleteCurrentAccount() async {
    final loggedInUserId = await getCurrentlyLoggedInUserId();
    if (loggedInUserId == null) {
      throw Exception('Cannot delete current account if not logged in!');
    }

    final registeredUsers = await registeredUsersDataSource.getData() ?? {};
    registeredUsers.removeWhere((loginToken, id) => id == loggedInUserId);
    await registeredUsersDataSource.saveData(registeredUsers);

    await logout();
  }

  /// Emulates phone number verification by asking the user to type in the same phone number as the sms code.
  @override
  Future<String> loginWithPhoneNumber({
    required String phoneNumber,
    required Future<String?> Function() smsCodeGetter,
  }) async {
    final smsCode = await smsCodeGetter();
    if (phoneNumber != smsCode) {
      throw Exception('Invalid SMS Code! Use the phone number as the SMS code.');
    }

    // Generate a user with fake email and password and login/signup.
    final userEmail = '$phoneNumber@phone.com';
    final userPassword = phoneNumber;

    final registeredUsers = (await registeredUsersDataSource.getData()) ?? {};
    final alreadyLoggedIn = registeredUsers.entries.any((entry) => entry.key.email == userEmail);
    if (alreadyLoggedIn) {
      return await login(email: userEmail, password: userPassword);
    } else {
      return await signup(email: userEmail, password: userPassword);
    }
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
