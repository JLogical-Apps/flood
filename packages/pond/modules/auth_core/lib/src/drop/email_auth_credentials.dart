import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/auth_credentials/email_auth_credentials.dart';
import 'package:auth_core/src/drop/auth_credentials.dart';
import 'package:drop_core/drop_core.dart';

class EmailAuthCredentialsValueObject extends AuthCredentialsValueObject {
  static const emailField = 'email';
  late final emailProperty = field<String>(name: emailField).isNotBlank();

  static const passwordField = 'password';
  late final passwordProperty = field<String>(name: passwordField).isNotBlank();

  @override
  String get key => emailProperty.value;

  @override
  bool matches(AuthCredentials credentials) {
    return credentials is EmailAuthCredentials &&
        credentials.email == emailProperty.value &&
        credentials.password == passwordProperty.value;
  }

  @override
  List<ValueObjectBehavior> get behaviors => super.behaviors + [emailProperty, passwordProperty];
}
