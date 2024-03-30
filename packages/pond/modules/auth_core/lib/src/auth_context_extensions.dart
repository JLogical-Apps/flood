import 'package:auth_core/src/auth_core_component.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension AuthCorePondContextExtensions on CorePondContext {
  AuthCoreComponent get authCoreComponent => locate<AuthCoreComponent>();
}
