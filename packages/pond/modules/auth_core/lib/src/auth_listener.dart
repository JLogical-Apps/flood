import 'dart:async';

import 'package:auth_core/src/account.dart';

class AuthListener {
  final FutureOr Function(Account account)? onAfterLogin;
  final FutureOr Function(Account account)? onBeforeLogout;

  AuthListener({this.onAfterLogin, this.onBeforeLogout});

  Future<void> beforeLogout(Account account) async {
    await onBeforeLogout?.call(account);
  }

  Future<void> afterLogin(Account account) async {
    await onAfterLogin?.call(account);
  }
}
