import 'dart:async';

import 'package:jlogical_utils/src/pond/modules/environment/default_environment_data.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_data_source.dart';
import 'package:jlogical_utils/src/pond/modules/environment/environment_module.dart';

import '../../context/app_context.dart';
import '../../context/module/app_module.dart';
import '../../context/registration/app_registration.dart';
import '../environment/environment.dart';
import 'auth_service.dart';
import 'file_auth_service.dart';
import 'firebase_auth_service.dart';
import 'local_auth_service.dart';

class DefaultAuthModule extends AppModule {
  final bool shouldAutoSignUpForTesting;
  final FutureOr Function(String userId, String email)? onAutoSignUp;

  DefaultAuthModule({this.shouldAutoSignUpForTesting: true, this.onAutoSignUp});

  @override
  void onRegister(AppRegistration registration) {
    registration
        .register<AuthService>(_getAuthService(DefaultEnvironmentData.getDataSource(AppContext.global.environment)));
  }

  @override
  Future<void> onLoad(AppContext context) async {
    if (shouldAutoSignUpForTesting && context.environment == Environment.testing) {
      final email = 'test@test.com';
      final userId = await locate<AuthService>().signup(email: email, password: 'password');
      await onAutoSignUp?.call(userId, email);
    }
  }

  AuthService _getAuthService(EnvironmentDataSource dataSource) {
    switch (dataSource) {
      case EnvironmentDataSource.memory:
        return LocalAuthService();
      case EnvironmentDataSource.file:
        return FileAuthService(authDirectory: 'auth');
      case EnvironmentDataSource.online:
        return FirebaseAuthService();
    }
  }
}
