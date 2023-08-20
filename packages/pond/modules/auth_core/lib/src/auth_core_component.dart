import 'package:actions_core/actions_core.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:auth_core/src/auth_service_implementation.dart';
import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';

class AuthCoreComponent with IsAuthServiceWrapper {
  @override
  final AuthService authService;

  final List<AuthServiceImplementation> authServiceImplementations;

  final BehaviorSubject<String?> _authenticatedUserIdX = BehaviorSubject.seeded(null);
  late final ValueStream<String?> authenticatedUserIdX = _authenticatedUserIdX;

  AuthCoreComponent({required this.authService, this.authServiceImplementations = const []});

  @override
  List<CorePondComponentBehavior> get behaviors =>
      super.behaviors +
      [
        CorePondComponentBehavior(
          onRegister: (context, _) async {
            final initialLoggedInUserId = await getLoggedInUserId();
            _authenticatedUserIdX.value = initialLoggedInUserId;
          },
        ),
      ];

  late final loginAction = Action(
    name: 'Login',
    runner: (LoginParameters parameters) async {
      final userId = await authService.login(parameters.email, parameters.password);
      _authenticatedUserIdX.value = userId;
      return userId;
    },
  );

  late final signupAction = Action(
    name: 'Signup',
    runner: (SignupParameters parameters) async {
      final userId = await authService.signup(parameters.email, parameters.password);
      _authenticatedUserIdX.value = userId;
      return userId;
    },
  );

  late final logoutAction = Action(
    name: 'Logout',
    runner: (_) async {
      _authenticatedUserIdX.value = null;
      await authService.logout();
    },
  );

  @override
  Future<String> login(String email, String password) async {
    return await context.run(loginAction, LoginParameters(email: email, password: password));
  }

  @override
  Future<String> signup(String email, String password) async {
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
