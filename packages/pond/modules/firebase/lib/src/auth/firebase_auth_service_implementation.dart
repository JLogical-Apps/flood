import 'package:auth_core/auth_core.dart';
import 'package:firebase/src/auth/firebase_auth_service.dart';

class FirebaseAuthServiceImplementation with IsAuthServiceImplementation<CloudAuthService> {
  @override
  AuthService getImplementation(CloudAuthService prototype) {
    return FirebaseAuthService();
  }
}
