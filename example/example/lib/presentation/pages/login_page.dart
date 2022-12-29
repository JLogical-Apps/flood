import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LoginPage extends AppPage {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledPage(
      body: Center(
        child: StyledText.body('Login'),
      ),
    );
  }

  @override
  AppPage copy() {
    return LoginPage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('login');
}
