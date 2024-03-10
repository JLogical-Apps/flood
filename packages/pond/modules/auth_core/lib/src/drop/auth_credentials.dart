import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/auth_credentials/email_auth_credentials.dart';
import 'package:auth_core/src/auth_credentials/phone_otp_auth_credentials.dart';
import 'package:auth_core/src/drop/email_auth_credentials.dart';
import 'package:auth_core/src/drop/phone_otp_auth_credentials.dart';
import 'package:drop_core/drop_core.dart';

abstract class AuthCredentialsValueObject extends ValueObject {
  String get key;

  bool matches(AuthCredentials credentials);

  static AuthCredentialsValueObject fromAuthCredentials(AuthCredentials credentials) {
    if (credentials is EmailAuthCredentials) {
      return EmailAuthCredentialsValueObject()
        ..emailProperty.set(credentials.email)
        ..passwordProperty.set(credentials.password);
    } else if (credentials is PhoneOtpAuthCredentials) {
      return PhoneOtpAuthCredentialsValueObject()..phoneNumberProperty.set(credentials.phoneNumber);
    }

    throw UnimplementedError();
  }
}
