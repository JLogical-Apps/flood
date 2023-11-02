import 'package:auth_core/auth_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

Account? useLoggedInUserAccountOrNull() {
  return useValueStream(useMemoized(() => useAppPondContext().find<AuthCoreComponent>().accountX)).getOrNull();
}

Account useLoggedInUserAccount() {
  return useLoggedInUserAccountOrNull() ?? (throw Exception('Could not get logged in user account!'));
}

String? useLoggedInUserIdOrNull() {
  return useLoggedInUserAccountOrNull()?.accountId;
}

String useLoggedInUserId() {
  return useLoggedInUserIdOrNull() ?? (throw Exception('Could not get logged in user id!'));
}
