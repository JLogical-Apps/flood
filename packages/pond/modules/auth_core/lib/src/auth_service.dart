import 'dart:async';

import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/adapting_auth_service.dart';
import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/auth_listener.dart';
import 'package:auth_core/src/cloud_auth_service.dart';
import 'package:auth_core/src/file_auth_service.dart';
import 'package:auth_core/src/listener_auth_service.dart';
import 'package:auth_core/src/listener_handler_auth_service.dart';
import 'package:auth_core/src/memory_auth_service.dart';
import 'package:auth_core/src/otp/otp_provider.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class AuthService with IsCorePondComponent {
  Future<Account> login(AuthCredentials authCredentials);

  Future<Account> signup(AuthCredentials authCredentials);

  Future<Account> loginWithOtp(OtpProvider otpProvider);

  Future<Account> createAccount(AuthCredentials authCredentials);

  Future<void> logout();

  Future<void> delete();

  Future<void> resetPassword(String email);

  ValueStream<FutureValue<Account?>> get accountX;

  static AuthServiceStatic get static => AuthServiceStatic();
}

extension AuthServiceExtension on AuthService {
  Account? get loggedInAccount => accountX.value.getOrNull();

  ValueStream<FutureValue<String?>> get userIdX =>
      accountX.mapWithValue((account) => account.map((account) => account?.accountId));

  String? get loggedInUserId => userIdX.value.getOrNull();

  AuthService withListener({
    FutureOr Function(Account account)? onAfterLogin,
    FutureOr Function(Account account)? onBeforeLogout,
  }) =>
      ListenerAuthService(
        authService: this,
        onAfterLogin: onAfterLogin,
        onBeforeLogout: onBeforeLogout,
      );

  AuthService withListenersHandler(List<AuthListener> authListeners) =>
      ListenerHandlerAuthService(authService: this, authListeners: authListeners);

  Future<Account> loginOrSignup(AuthCredentials credentials) async {
    final account = await guardAsync(() => login(credentials));
    if (account != null) {
      return account;
    }

    return await signup(credentials);
  }
}

class AuthServiceStatic {
  MemoryAuthService memory({bool isAdmin = false}) {
    return MemoryAuthService(isAdmin: isAdmin);
  }

  FileAuthService file() {
    return FileAuthService();
  }

  AdaptingAuthService adapting({bool memoryIsAdmin = false}) {
    return AdaptingAuthService(memoryIsAdmin: memoryIsAdmin);
  }

  CloudAuthService cloud() {
    return CloudAuthService();
  }
}

mixin IsAuthService implements AuthService {
  @override
  Future<void> resetPassword(String email) {
    throw UnimplementedError();
  }
}

abstract class AuthServiceWrapper implements AuthService {
  AuthService get authService;
}

mixin IsAuthServiceWrapper implements AuthServiceWrapper {
  @override
  Future<Account> login(AuthCredentials authCredentials) => authService.login(authCredentials);

  @override
  Future<Account> loginWithOtp(OtpProvider otpProvider) => authService.loginWithOtp(otpProvider);

  @override
  Future<Account> signup(AuthCredentials authCredentials) => authService.signup(authCredentials);

  @override
  Future<Account> createAccount(AuthCredentials authCredentials) => authService.createAccount(authCredentials);

  @override
  Future<void> logout() => authService.logout();

  @override
  Future<void> delete() => authService.delete();

  @override
  Future<void> resetPassword(String email) => authService.resetPassword(email);

  @override
  late ValueStream<FutureValue<Account?>> accountX = authService.accountX;

  late CorePondContext _context;

  @override
  CorePondContext get context => _context;

  @override
  set context(CorePondContext context) {
    _context = context;
    authService.context = context;
  }

  @override
  List<CorePondComponentBehavior> get behaviors => authService.behaviors;
}
