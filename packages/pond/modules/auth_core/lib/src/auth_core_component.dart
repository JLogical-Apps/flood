import 'dart:async';

import 'package:actions_core/actions_core.dart';
import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/auth_listener.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:auth_core/src/auth_service_implementation.dart';
import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';

class AuthCoreComponent with IsAuthServiceWrapper {
  @override
  final AuthService authService;

  final List<AuthServiceImplementation> authServiceImplementations;
  final List<AuthListener> authListeners;

  AuthCoreComponent._({
    required AuthService authService,
    this.authServiceImplementations = const [],
    required this.authListeners,
  }) : authService = authService.withListenersHandler(authListeners);

  factory AuthCoreComponent({
    required AuthService authService,
    List<AuthServiceImplementation> authServiceImplementations = const [],
    List<AuthListener>? authListeners,
  }) {
    authListeners ??= [];
    return AuthCoreComponent._(
      authService: authService,
      authServiceImplementations: authServiceImplementations,
      authListeners: authListeners,
    );
  }

  @override
  List<CorePondComponentBehavior> get behaviors =>
      super.behaviors +
      [
        CorePondComponentBehavior(
          onReset: (context, __) async {
            await logout();
          },
        ),
      ];

  void addListener({
    FutureOr Function(Account account)? onBeforeLogout,
    FutureOr Function(Account account)? onAfterLogin,
  }) {
    authListeners.add(AuthListener(onBeforeLogout: onBeforeLogout, onAfterLogin: onAfterLogin));
  }

  late final loginAction = Action(
    name: 'Login',
    runner: (AuthCredentials credentials) => authService.login(credentials),
  );

  late final signupAction = Action(
    name: 'Signup',
    runner: (AuthCredentials credentials) => authService.signup(credentials),
  );

  late final logoutAction = Action(
    name: 'Logout',
    runner: (_) => authService.logout(),
  );

  @override
  Future<Account> login(AuthCredentials authCredentials) async {
    return await context.run(loginAction, authCredentials);
  }

  @override
  Future<Account> signup(AuthCredentials authCredentials) async {
    return await context.run(signupAction, authCredentials);
  }

  @override
  Future<void> logout() async {
    await context.run(logoutAction, null as dynamic);
  }

  AuthService? getImplementationOrNull(AuthService authService) {
    return authServiceImplementations
        .firstWhereOrNull((implementation) => implementation.authServiceType == authService.runtimeType)
        ?.getImplementation(authService);
  }

  AuthService getImplementation(AuthService authService) {
    return getImplementationOrNull(authService) ??
        (throw Exception('Could not find implementation for auth service [$authService]'));
  }
}

class LoginParameters {
  final String email;
  final String password;

  LoginParameters({required this.email, required this.password});

  @override
  String toString() {
    return 'LoginParameters($email, ...)';
  }
}

class SignupParameters {
  final String email;
  final String password;

  SignupParameters({required this.email, required this.password});

  @override
  String toString() {
    return 'SignupParameters($email, ...)';
  }
}
