import 'package:actions_core/actions_core.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';

class AuthCoreComponent with IsAuthServiceWrapper, IsCorePondComponentWrapper {
  @override
  final AuthService authService;

  final BehaviorSubject<String?> _authenticatedUserIdX = BehaviorSubject.seeded(null);
  late final ValueStream<String?> authenticatedUserIdX = _authenticatedUserIdX;

  AuthCoreComponent({required this.authService});

  AuthCoreComponent.memory() : authService = AuthService.static.memory();

  AuthCoreComponent.adapting() : authService = AuthService.static.adapting();

  @override
  CorePondComponent get corePondComponent => authService;

  @override
  List<CorePondComponentBehavior> get behaviors =>
      corePondComponent.behaviors +
      [
        CorePondComponentBehavior(onLoad: (context, _) async {
          final initialLoggedInUserId = await getLoggedInUserId();
          _authenticatedUserIdX.value = initialLoggedInUserId;
        }),
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
