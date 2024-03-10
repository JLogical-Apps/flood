import 'dart:async';

import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/otp/otp_provider.dart';
import 'package:auth_core/src/otp/otp_request_type.dart';

class PhoneOtpProvider with IsOtpProvider {
  final String phoneNumber;
  final FutureOr<String> Function(OtpRequestType requestType) smsCodeGetter;

  PhoneOtpProvider({required this.phoneNumber, required this.smsCodeGetter});

  @override
  Future<String> getOtpUserCode(OtpRequestType requestType) async => await smsCodeGetter(requestType);

  @override
  AuthCredentials generateAuthCredentials() => AuthCredentials.phoneOtp(phoneNumber: phoneNumber);
}
