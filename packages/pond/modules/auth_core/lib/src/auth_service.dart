import 'dart:async';

import 'package:auth_core/src/adapting_auth_service.dart';
import 'package:auth_core/src/cloud_auth_service.dart';
import 'package:auth_core/src/file_auth_service.dart';
import 'package:auth_core/src/listener_auth_service.dart';
import 'package:auth_core/src/memory_auth_service.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

abstract class AuthService with IsCorePondComponent {
  Future<String> login(String email, String password);

  Future<String> signup(String email, String password);

  Future<void> logout();

  ValueStream<FutureValue<String?>> get userIdX;

  static AuthServiceStatic get static => AuthServiceStatic();
}

extension AuthServiceExtension on AuthService {
  String? get loggedInUserId => userIdX.value.getOrNull();

  AuthService withListener({
    FutureOr Function(String userId)? onAfterLogin,
    FutureOr Function(String userId)? onBeforeLogout,
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
  Future<String> login(String email, String password) => authService.login(email, password);

  @override
  Future<String> signup(String email, String password) => authService.signup(email, password);

  @override
  Future<void> logout() => authService.logout();

  @override
  ValueStream<FutureValue<String?>> get userIdX => authService.userIdX;

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