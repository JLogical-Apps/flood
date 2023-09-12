import 'dart:async';

import 'package:auth_core/auth_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class ListenerAuthService with IsAuthServiceWrapper {
  @override
  final AuthService authService;

  final FutureOr Function(String userId)? onAfterLogin;
  final FutureOr Function(String userId)? onBeforeLogout;

  ListenerAuthService({required this.authService, this.onAfterLogin, this.onBeforeLogout});

  @override
  List<CorePondComponentBehavior> get behaviors =>
      super.behaviors +
      [
        CorePondComponentBehavior(
          onLoad: (context, component) async {
            authService.userIdX.listen((maybeUserId) async {
              final userId = maybeUserId.getOrNull();
              if (userId != null) {
                await onAfterLogin?.call(userId);
              }
            });
          },
        ),
      ];

  @override
  Future<String> login(String email, String password) async {
    final userId = await authService.login(email, password);
    await onAfterLogin?.call(userId);
    return userId;
  }

  @override
  Future<String> signup(String email, String password) async {
    final userId = await authService.signup(email, password);
    await onAfterLogin?.call(userId);
    return userId;
  }

  @override
  Future<void> logout() async {
    if (loggedInUserId != null) {
      await onBeforeLogout?.call(loggedInUserId!);
    }

    await authService.logout();
  }
}