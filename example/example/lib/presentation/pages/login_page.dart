import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LoginPage extends AppPage {
  late final redirectPathProperty = field<String>(name: 'redirect');

  @override
  Widget build(BuildContext context) {
    final emailState = useState<String>('');
    final passwordState = useState<String>('');

    return StyledPage(
      body: StyledList.column.centered.withScrollbar(
        children: [
          StyledContainer.strong(
            width: 200,
            height: 200,
          ),
          StyledText.h1.strong('Welcome to Valet'),
          StyledDivider(),
          StyledTextField(
            labelText: 'Email',
            text: emailState.value,
            onChanged: (text) => emailState.value = text,
          ),
          StyledTextField(
            labelText: 'Password',
            text: passwordState.value,
            onChanged: (text) => passwordState.value = text,
          ),
          StyledList.row.centered.withScrollbar(children: [
            StyledButton(
              labelText: 'Login',
              onPressed: () {},
            ),
            StyledButton.strong(
              labelText: 'Sign Up',
              onPressed: () {},
            ),
          ]),
        ],
      ),
    );
  }

  @override
  AppPage copy() {
    return LoginPage();
  }

  @override
  PathDefinition get pathDefinition => PathDefinition.string('login');

  @override
  List<RouteProperty> get queryProperties => [redirectPathProperty];
}
