import 'package:auth_core/src/auth_credentials/auth_credentials.dart';

class PhoneOtpAuthCredentials with IsAuthCredentials {
  final String phoneNumber;

  PhoneOtpAuthCredentials({required this.phoneNumber});
}
