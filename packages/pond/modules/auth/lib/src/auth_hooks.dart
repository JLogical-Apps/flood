import 'package:auth_core/auth_core.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';

Model<String?> useLoggedInUserId() {
  return useFutureModel(() => useAppPondContext().find<AuthCoreComponent>().getLoggedInUserId());
}
