import 'package:actions_core/actions_core.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:pond_core/pond_core.dart';

class AuthCoreComponent with IsAuthServiceWrapper, IsCorePondComponentWrapper {
  @override
  final AuthService authService;

  AuthCoreComponent({required this.authService});

  AuthCoreComponent.memory() : authService = AuthService.static.memory();

  AuthCoreComponent.adapting() : authService = AuthService.static.adapting();

  @override
  CorePondComponent get corePondComponent => authService;

  late final loginAction = Action(
    name: 'Login',
    runner: (LoginParameters parameters) async {
      return await authService.login(parameters.email, parameters.password);
    },
  );

  late final signupAction = Action(
    name: 'Signup',
    runner: (SignupParameters parameters) async {
      return await authService.signup(parameters.email, parameters.password);
    },
  );

  late final logoutAction = Action(
    name: 'Logout',
    runner: (_) async {
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
