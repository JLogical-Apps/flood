import 'dart:io';

import 'package:jlogical_utils/src/pond/auth/auth_service.dart';
import 'package:jlogical_utils/src/pond/auth/file_auth_service.dart';
import 'package:jlogical_utils/src/pond/auth/firebase_auth_service.dart';
import 'package:jlogical_utils/src/pond/auth/local_auth_service.dart';
import 'package:jlogical_utils/src/pond/context/environment/default_environment_data.dart';
import 'package:jlogical_utils/src/pond/context/environment/environment_data_source.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';

class DefaultAuthModule extends AppModule {
  final Directory parentDirectory;

  DefaultAuthModule({required this.parentDirectory});

  @override
  void onRegister(AppRegistration registration) {
    registration.register<AuthService>(_getAuthService(DefaultEnvironmentData.getDataSource(registration.environment)));
  }

  AuthService _getAuthService(EnvironmentDataSource dataSource) {
    switch (dataSource) {
      case EnvironmentDataSource.memory:
        return LocalAuthService();
      case EnvironmentDataSource.file:
        return FileAuthService(parentDirectory: parentDirectory);
      case EnvironmentDataSource.online:
        return FirebaseAuthService();
    }
  }
}
