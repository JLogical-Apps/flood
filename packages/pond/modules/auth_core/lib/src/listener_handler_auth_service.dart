import 'package:auth_core/auth_core.dart';
import 'package:auth_core/src/auth_listener.dart';

class ListenerHandlerAuthService with IsAuthServiceWrapper {
  @override
  final AuthService authService;

  final List<AuthListener> authListeners;

  ListenerHandlerAuthService({required AuthService authService, required this.authListeners})
      : authService = authService.withListener(
          onAfterLogin: (account) async {
            for (final authListener in authListeners) {
              await authListener.afterLogin(account);
            }
          },
          onBeforeLogout: (account) async {
            for (final authListener in authListeners) {
              await authListener.beforeLogout(account);
            }
          },
        );
}
