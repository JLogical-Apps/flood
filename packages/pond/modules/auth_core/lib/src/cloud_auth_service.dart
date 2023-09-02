import 'package:auth_core/auth_core.dart';
import 'package:auth_core/src/blank_auth_service.dart';
import 'package:utils_core/utils_core.dart';

class CloudAuthService with IsAuthServiceWrapper {
  @override
  late final AuthService authService =
      context.locate<AuthCoreComponent>().getImplementationOrNull(this) ?? BlankAuthService();
}
