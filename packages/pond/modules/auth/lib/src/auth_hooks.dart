import 'package:auth_core/auth_core.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

String? useLoggedInUserIdOrNull() {
  return useValueStream(useAppPondContext().find<AuthCoreComponent>().userIdX).getOrNull();
}

String useLoggedInUserId() {
  return useLoggedInUserIdOrNull() ?? (throw Exception('Could not get logged in user id!'));
}
