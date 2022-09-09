import 'package:jlogical_utils/src/utils/export.dart';

import '../../context/app_context.dart';
import 'auth_service.dart';

String? useLoggedInUserOrNull() {
  return useMemoizedFuture(() => () async {
        final authService = locate<AuthService>();
        final loggedInUserId = await authService.getCurrentlyLoggedInUserId();
        return loggedInUserId;
      }()).data;
}

String useLoggedInUser() {
  return useLoggedInUserOrNull() ?? (throw Exception('No logged in user!'));
}
