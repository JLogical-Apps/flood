import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TestLoginPage extends HookWidget {
  final Style style;

  const TestLoginPage({
    Key? key,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final port = useMemoized(() => Port(
          fields: [
            StringPortField(name: 'username').required(),
            StringPortField(name: 'password').required().isPassword(),
            OptionsPortField(
              name: 'favoriteFood',
              options: ['Pizza', 'Hamburger', 'Pineapples'],
            ).required(),
            DatePortField(name: 'dob').required().isBeforeNow(),
            OptionsPortField(name: 'gender', options: ['m', 'f']).required(),
            BoolPortField(name: 'acceptTerms').required(),
          ],
        ));
    return StyleProvider(
      style: style,
      child: StyledPage(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        body: PortBuilder(
          port: port,
          child: ScrollColumn.withScrollbar(
            children: [
              StyledCategory.medium(
                headerText: 'Login',
                children: [
                  StyledTextPortField(
                    name: 'username',
                    labelText: 'Username',
                  ),
                  StyledTextPortField(
                    name: 'password',
                    labelText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  StyledOptionsPortField(
                    name: 'favoriteFood',
                    labelText: 'Favorite Food',
                  ),
                  StyledDatePortField(
                    name: 'dob',
                    labelText: 'Date of Birth',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StyledRadioOptionPortField<String>(
                        groupName: 'gender',
                        radioValue: 'm',
                        labelText: 'Male',
                      ),
                      StyledRadioOptionPortField<String>(
                        groupName: 'gender',
                        radioValue: 'f',
                        labelText: 'Female',
                      ),
                    ],
                  ),
                  StyledCheckboxPortField(
                    name: 'acceptTerms',
                    labelText: 'Accept Terms and Conditions?',
                  ),
                  ButtonBar(
                    children: [
                      StyledButton.high(
                        text: 'Sign Up',
                        onTapped: () {},
                      ),
                      StyledButton.low(
                        text: 'Log In',
                        onTapped: () async {
                          await Future.delayed(Duration(seconds: 1));
                          await port.submit();
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
