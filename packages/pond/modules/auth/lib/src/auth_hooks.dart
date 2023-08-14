import 'package:auth_core/auth_core.dart';
import 'package:model/model.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

Model<String?> useLoggedInUserIdModel() {
  return useFutureModel(() => useAppPondContext().find<AuthCoreComponent>().getLoggedInUserId());
}

String? useLoggedInUserId() {
  return useValueStream(useAppPondContext().find<AuthCoreComponent>().authenticatedUserIdX);
}
