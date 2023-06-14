import 'package:auth_core/src/auth_service.dart';
import 'package:environment_core/environment_core.dart';
import 'package:pond_core/pond_core.dart';

class AdaptingAuthService with IsAuthServiceWrapper, IsCorePondComponentWrapper {
  final AuthService Function(EnvironmentType environment)? authServiceGetter;

  AdaptingAuthService({this.authServiceGetter});

  @override
  late final AuthService authService =
      authServiceGetter?.call(context.environment) ?? _getDefaultAuthService(context.environment);

  @override
  CorePondComponent get corePondComponent => authService;

  AuthService _getDefaultAuthService(EnvironmentType environment) {
    if (environment == EnvironmentType.static.testing) {
      return AuthService.static.memory();
    }
    if (environment == EnvironmentType.static.device) {
      return AuthService.static.file();
    }

    throw Exception('Unknown auth service');
  }
}
