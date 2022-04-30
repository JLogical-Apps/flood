import 'package:equatable/equatable.dart';

import '../../../persistence/export_core.dart';
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
}

/// Token used to simulate logging in. Only used for local testing purposes.
class _LoginToken extends Equatable {
  final String email;
  final String password;

  const _LoginToken({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
