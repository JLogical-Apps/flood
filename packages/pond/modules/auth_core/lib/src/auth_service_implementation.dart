import 'package:auth_core/src/auth_service.dart';

abstract class AuthServiceImplementation<T extends AuthService> {
  AuthService getImplementation(T prototype);

  Type get authServiceType;
}

mixin IsAuthServiceImplementation<T extends AuthService> implements AuthServiceImplementation<T> {
  @override
  Type get authServiceType => T;
}
