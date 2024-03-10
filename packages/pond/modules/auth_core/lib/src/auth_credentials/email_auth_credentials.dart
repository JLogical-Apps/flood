import 'package:auth_core/src/auth_credentials/auth_credentials.dart';

class EmailAuthCredentials with IsAuthCredentials {
  final String email;
  final String password;

  EmailAuthCredentials({required this.email, required this.password});
}
