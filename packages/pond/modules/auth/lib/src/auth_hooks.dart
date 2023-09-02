import 'package:auth_core/auth_core.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

String? useLoggedInUserId() {
  return useValueStream(useAppPondContext().find<AuthCoreComponent>().userIdX).getOrNull();
}
