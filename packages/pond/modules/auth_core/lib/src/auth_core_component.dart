import 'package:actions_core/actions_core.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AuthCoreComponent with IsCorePondComponent, IsAuthServiceWrapper {
  @override
  final AuthService authService;

  AuthCoreComponent({required this.authService});

  AuthCoreComponent.memory() : authService = AuthService.memory();

  AuthCoreComponent.adapting() : authService = AuthService.adapting();

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) => context.register(authService),
        ),
      ];

  late final loginAction = Action(
    name: 'Login',
    runner: (LoginParameters parameters) async {
      return await login(parameters.email, parameters.password);
    },
  );

  late final signupAction = Action(
    name: 'Signup',
    runner: (SignupParameters parameters) async {
      return await signup(parameters.email, parameters.password);
    },
  );
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
