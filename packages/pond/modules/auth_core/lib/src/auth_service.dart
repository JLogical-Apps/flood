import 'dart:async';

import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/adapting_auth_service.dart';
import 'package:auth_core/src/cloud_auth_service.dart';
import 'package:auth_core/src/file_auth_service.dart';
import 'package:auth_core/src/listener_auth_service.dart';
import 'package:auth_core/src/memory_auth_service.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class AuthService with IsCorePondComponent {
  Future<Account> login(String email, String password);

  Future<Account> signup(String email, String password);

  Future<void> logout();

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
}

class AuthServiceStatic {
  MemoryAuthService memory() {
    return MemoryAuthService();
  }

  FileAuthService file() {
    return FileAuthService();
  }

  AdaptingAuthService adapting() {
    return AdaptingAuthService();
  }

  CloudAuthService cloud() {
    return CloudAuthService();
  }
}

mixin IsAuthService implements AuthService {}

abstract class AuthServiceWrapper implements AuthService {
  AuthService get authService;
}

mixin IsAuthServiceWrapper implements AuthServiceWrapper {
  @override
  Future<Account> login(String email, String password) => authService.login(email, password);

  @override
  Future<Account> signup(String email, String password) => authService.signup(email, password);

  @override
  Future<void> logout() => authService.logout();

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
