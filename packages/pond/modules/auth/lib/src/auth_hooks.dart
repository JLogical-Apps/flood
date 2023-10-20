import 'package:auth_core/auth_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

String? useLoggedInUserIdOrNull() {
  return useValueStream(useMemoized(() => useAppPondContext().find<AuthCoreComponent>().userIdX)).getOrNull();
}

String useLoggedInUserId() {
  return useLoggedInUserIdOrNull() ?? (throw Exception('Could not get logged in user id!'));
}
