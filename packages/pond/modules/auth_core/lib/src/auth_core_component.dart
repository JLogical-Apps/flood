import 'package:auth_core/src/auth_service.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AuthCoreComponent with IsCorePondComponent, IsCorePondComponentBehavior, IsAuthServiceWrapper {
  @override
  final AuthService authService;

  AuthCoreComponent({required this.authService});

  AuthCoreComponent.memory() : authService = AuthService.memory();

  AuthCoreComponent.adapting() : authService = AuthService.adapting();

  @override
  Future onRegister(CorePondContext context, CorePondComponent component) async {
    await context.register(authService);
  }

  @override
  List<CorePondComponentBehavior> get behaviors => [this];
}
