import 'package:auth_core/src/adapting_auth_service.dart';
import 'package:auth_core/src/memory_auth_service.dart';
import 'package:pond_core/pond_core.dart';

abstract class AuthService with IsCorePondComponent {
  Future<String?> getLoggedInUserId();

  Future<String> login(String email, String password);

  Future<String> signup(String email, String password);

  Future<void> logout();

  static MemoryAuthService memory() {
    return MemoryAuthService();
  }

  static AdaptingAuthService adapting() {
    return AdaptingAuthService();
  }
}

mixin IsAuthService implements AuthService {}

abstract class AuthServiceWrapper implements AuthService {
  AuthService get authService;
}

mixin IsAuthServiceWrapper implements AuthServiceWrapper {
  @override
  Future<String?> getLoggedInUserId() => authService.getLoggedInUserId();

  @override
  Future<String> login(String email, String password) => authService.login(email, password);

  @override
  Future<String> signup(String email, String password) => authService.signup(email, password);

  @override
  Future<void> logout() => authService.logout();
}
