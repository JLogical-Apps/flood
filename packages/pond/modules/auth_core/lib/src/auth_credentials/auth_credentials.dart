import 'package:auth_core/src/auth_credentials/email_auth_credentials.dart';
import 'package:auth_core/src/auth_credentials/phone_otp_auth_credentials.dart';

abstract class AuthCredentials {
  static AuthCredentials email({required String email, required String password}) =>
      EmailAuthCredentials(email: email, password: password);

  static AuthCredentials phoneOtp({required String phoneNumber}) => PhoneOtpAuthCredentials(phoneNumber: phoneNumber);
}

mixin IsAuthCredentials implements AuthCredentials {}
