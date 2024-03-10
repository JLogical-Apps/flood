import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/auth_credentials/phone_otp_auth_credentials.dart';
import 'package:auth_core/src/drop/auth_credentials.dart';
import 'package:drop_core/drop_core.dart';

class PhoneOtpAuthCredentialsValueObject extends AuthCredentialsValueObject {
  static const phoneNumberField = 'phoneNumber';
  late final phoneNumberProperty = field<String>(name: phoneNumberField).isNotBlank();

  @override
  String get key => phoneNumberProperty.value;

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [phoneNumberProperty];

  @override
  bool matches(AuthCredentials credentials) {
    return credentials is PhoneOtpAuthCredentials && credentials.phoneNumber == phoneNumberProperty.value;
  }
}
