import 'package:auth_core/src/auth_service.dart';
import 'package:environment_core/environment_core.dart';

class AdaptingAuthService with IsAuthServiceWrapper {
  final AuthService Function(EnvironmentType environment)? authServiceGetter;
  final bool memoryIsAdmin;

  AdaptingAuthService({this.authServiceGetter, this.memoryIsAdmin = false});

  @override
  late final AuthService authService =
      authServiceGetter?.call(context.environment) ?? _getDefaultAuthService(context.environment);

  AuthService _getDefaultAuthService(EnvironmentType environment) {
    if (environment == EnvironmentType.static.testing) {
      return AuthService.static.memory(isAdmin: memoryIsAdmin);
    }
    if (environment == EnvironmentType.static.device) {
      return AuthService.static.file();
    }

    return AuthService.static.cloud();
  }
}
