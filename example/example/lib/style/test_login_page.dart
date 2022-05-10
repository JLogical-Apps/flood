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
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
        },
        body: SmartForm(
          controller: smartFormController,
          child: ScrollColumn.withScrollbar(
            children: [
              StyledCategory.medium(
                headerText: 'Login',
                children: [
                  StyledSmartTextField(
                    name: 'username',
                    labelText: 'Username',
                    validators: [
                      Validation.required(),
                    ],
                  ),
                  StyledSmartTextField(
                    name: 'password',
                    labelText: 'Password',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validators: [
                      Validation.required(),
                    ],
                  ),
                  StyledSmartOptionsField(
                    name: 'favoriteFood',
                    labelText: 'Favorite Food',
                    options: ['Pizza', 'Hamburger', 'Pineapples'],
                    validators: [
                      Validation.required(),
                    ],
                  ),
                  StyledSmartDateField(
                    name: 'dob',
                    labelText: 'Date of Birth',
                    validators: [Validation.isBeforeNow()],
                  ),
                  SmartRadioGroup(group: 'gender'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StyledSmartRadioOptionField<String>(
                        group: 'gender',
                        radioValue: 'male',
                        labelText: 'Male',
                        validators: [Validation.required()],
                      ),
                      StyledSmartRadioOptionField<String>(
                        group: 'gender',
                        radioValue: 'female',
                        labelText: 'Female',
                      ),
                    ],
                  ),
                  StyledSmartBoolField(
                    name: 'acceptTerms',
                    labelText: 'Accept Terms and Conditions?',
                    validators: [
                      Validation.required(onEmpty: 'Must be accepted to log in!'),
                    ],
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
                          await smartFormController.validate();
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
