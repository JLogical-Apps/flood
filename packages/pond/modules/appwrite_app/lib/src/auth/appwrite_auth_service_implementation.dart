import 'package:appwrite_app/src/auth/appwrite_auth_service.dart';
import 'package:auth_core/auth_core.dart';

class AppwriteAuthServiceImplementation with IsAuthServiceImplementation<CloudAuthService> {
  @override
  AuthService getImplementation(CloudAuthService prototype) {
    return AppwriteAuthService();
  }
}
