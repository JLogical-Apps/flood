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
          print('hey');
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
                  StyledSmartDateField(
                    name: 'dob',
                    label: 'Date of Birth',
                    validators: [Validation.isBeforeNow()],
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
                        onTapped: () {},
                      ),
                      StyledButton.low(
                        text: 'Log In',
                        onTapped: () {
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
