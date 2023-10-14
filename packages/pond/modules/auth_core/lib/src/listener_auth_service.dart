import 'dart:async';

import 'package:auth_core/auth_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class ListenerAuthService with IsAuthServiceWrapper {
  @override
  final AuthService authService;

  final FutureOr Function(Account account)? onAfterLogin;
  final FutureOr Function(Account account)? onBeforeLogout;

  ListenerAuthService({required this.authService, this.onAfterLogin, this.onBeforeLogout});

  @override
  List<CorePondComponentBehavior> get behaviors =>
      super.behaviors +
      [
        CorePondComponentBehavior(
          onLoad: (context, component) async {
            authService.accountX.listen((maybeAccount) async {
              final account = maybeAccount.getOrNull();
              if (account != null) {
                await onAfterLogin?.call(account);
              }
            });
          },
        ),
      ];

  @override
  Future<Account> login(String email, String password) async {
    final account = await authService.login(email, password);
    await onAfterLogin?.call(account);
    return account;
  }

  @override
  Future<Account> signup(String email, String password) async {
    final account = await authService.signup(email, password);
    await onAfterLogin?.call(account);
    return account;
  }

  @override
  Future<void> logout() async {
    if (loggedInAccount != null) {
      await onBeforeLogout?.call(loggedInAccount!);
    }

    await authService.logout();
  }
}
