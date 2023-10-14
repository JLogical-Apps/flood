import 'package:actions_core/actions_core.dart';
import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:auth_core/src/auth_service_implementation.dart';
import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';

class AuthCoreComponent with IsAuthServiceWrapper {
  @override
  final AuthService authService;

  final List<AuthServiceImplementation> authServiceImplementations;

  AuthCoreComponent({required this.authService, this.authServiceImplementations = const []});

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

  late final loginAction = Action(
    name: 'Login',
    runner: (LoginParameters parameters) => authService.login(parameters.email, parameters.password),
  );

  late final signupAction = Action(
    name: 'Signup',
    runner: (SignupParameters parameters) => authService.signup(parameters.email, parameters.password),
  );

  late final logoutAction = Action(
    name: 'Logout',
    runner: (_) => authService.logout(),
  );

  @override
  Future<Account> login(String email, String password) async {
    return await context.run(loginAction, LoginParameters(email: email, password: password));
  }

  @override
  Future<Account> signup(String email, String password) async {
    return await context.run(signupAction, SignupParameters(email: email, password: password));
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
}

class SignupParameters {
  final String email;
  final String password;

  SignupParameters({required this.email, required this.password});
}
