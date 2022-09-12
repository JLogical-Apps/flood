import 'package:equatable/equatable.dart';

import '../../../persistence/export_core.dart';
import '../logging/default_logging_module.dart';
import 'auth_service.dart';
import 'login_failure.dart';
import 'signup_failure.dart';

class LocalAuthService extends AuthService {
  String? loggedInUserId;
  Map<_LoginToken, String> userIdByLogin = {};

  final UuidIdGenerator _uuidGenerator = UuidIdGenerator();

  @override
  Future<String?> getCurrentlyLoggedInUserId() async {
    return loggedInUserId;
  }

  @override
  Future<String> login({required String email, required String password}) async {
    final loginToken = _LoginToken(email: email, password: password);
    final userId = userIdByLogin[loginToken];
    if (userId == null) {
      throw LoginFailure.invalidEmail();
    }

    loggedInUserId = userId;

    return userId;
  }

  @override
  Future<String> signup({required String email, required String password}) async {
    final loginToken = _LoginToken(email: email, password: password);
    final existingUser = userIdByLogin[loginToken];
    if (existingUser != null) {
      throw SignupFailure.emailAlreadyUsed();
    }

    final userId = _uuidGenerator.getId();

    userIdByLogin[loginToken] = userId;

    loggedInUserId = userId;

    return userId;
  }

  @override
  Future<void> logout() async {
    loggedInUserId = null;
  }

  @override
  Future<void> deleteCurrentAccount() async {
    final loggedInUserId = await getCurrentlyLoggedInUserId();
    if (loggedInUserId == null) {
      throw Exception('Cannot delete current account if not logged in!');
    }

    userIdByLogin.removeWhere((loginToken, id) => id == loggedInUserId);

    await logout();
  }

  /// Emulates phone number verification by asking the user to type in the same phone number as the sms code.
  @override
  Future<String> loginWithPhoneNumber({
    required String phoneNumber,
    required Future<String?> Function(SmsCodeRequestType requestType) smsCodeGetter,
  }) async {
    var isSuccessful = false;
    var smsCodeType = SmsCodeRequestType.first;
    do {
      final smsCode = await smsCodeGetter(smsCodeType);
      if (smsCode == null) {
        throw Exception('SMS Code is empty.');
      }

      if (smsCode != phoneNumber) {
        smsCodeType = SmsCodeRequestType.retry;
        continue;
      }

      try {
        // Generate a user with fake email and password and login/signup.
        final userEmail = '$phoneNumber@phone.com';
        final userPassword = phoneNumber;

        final registeredUsers = userIdByLogin;
        final alreadyLoggedIn = registeredUsers.entries.any((entry) => entry.key.email == userEmail);
        if (alreadyLoggedIn) {
          return await login(email: userEmail, password: userPassword);
        } else {
          return await signup(email: userEmail, password: userPassword);
        }
      } catch (e) {
        logError(e);
        smsCodeType = SmsCodeRequestType.retry;
      }
    } while (!isSuccessful);
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
