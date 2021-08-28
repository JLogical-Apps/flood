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
    final smartFormController = useMemoized(() => SmartFormController());
    return StyleProvider(
      style: style,
      child: StyledPage(
        body: SmartForm(
          controller: smartFormController,
          child: ScrollColumn.withScrollbar(
            children: [
              StyledCategory.medium(
                header: 'Login',
                children: [
                  StyledSmartTextField(
                    name: 'username',
                    label: 'Username',
                    validators: [
                      Validation.required(),
                    ],
                  ),
                  StyledSmartTextField(
                    name: 'password',
                    label: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validators: [
                      Validation.required(),
                    ],
                  ),
                  StyledSmartOptionsField(
                    name: 'favoriteFood',
                    label: 'Favorite Food',
                    options: ['Pizza', 'Hamburger', 'Pineapples'],
                    validators: [
                      Validation.required(),
                    ],
                  ),
                  SmartRadioGroup(group: 'gender'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StyledSmartRadioOptionField<String>(
                        group: 'gender',
                        radioValue: 'male',
                        label: 'Male',
                        validators: [Validation.required()],
                      ),
                      StyledSmartRadioOptionField<String>(
                        group: 'gender',
                        radioValue: 'female',
                        label: 'Female',
                      ),
                    ],
                  ),
                  StyledSmartBoolField(
                    name: 'acceptTerms',
                    label: 'Accept Terms and Conditions?',
                    validators: [
                      Validation.required(onEmpty: 'Must be accepted to log in!'),
                    ],
                  ),
                  ButtonBar(
                    children: [
                      StyledButton.high(
                        text: 'Sign Up',
                        onTap: () {},
                      ),
                      StyledButton.low(
                        text: 'Log In',
                        onTap: () {
                          smartFormController.validate();
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
