import 'package:auth_core/src/auth_service.dart';
import 'package:environment_core/environment_core.dart';
import 'package:pond_core/pond_core.dart';

class AdaptingAuthService with IsCorePondComponentWrapper, IsAuthServiceWrapper {
  final AuthService Function(EnvironmentType environment)? authServiceGetter;

  AdaptingAuthService({this.authServiceGetter});

  @override
  late final AuthService authService =
      authServiceGetter?.call(context.environment) ?? _getDefaultAuthService(context.environment);

  @override
  late final CorePondComponent corePondComponent = authService;

  AuthService _getDefaultAuthService(EnvironmentType environment) {
    if (environment == EnvironmentType.static.testing) {
      return AuthService.memory();
    }

    throw Exception('Unknown auth service');
  }
}
