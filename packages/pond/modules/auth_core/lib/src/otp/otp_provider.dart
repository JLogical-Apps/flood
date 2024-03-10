import 'dart:async';

import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/otp/otp_request_type.dart';
import 'package:auth_core/src/otp/phone_otp_provider.dart';

abstract class OtpProvider {
  static PhoneOtpProvider phone({
    required String phoneNumber,
    required FutureOr<String> Function(OtpRequestType requestType) smsCodeGetter,
  }) =>
      PhoneOtpProvider(phoneNumber: phoneNumber, smsCodeGetter: smsCodeGetter);

  Future<String> getOtpUserCode(OtpRequestType requestType);

  AuthCredentials generateAuthCredentials();
}

mixin IsOtpProvider implements OtpProvider {}
