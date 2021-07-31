import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Page that shows off forms.
class FormPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    /// The last result of whether the form was successful or not.
    /// If [null], then the form hasn't been validated yet.
    var successX = useObservable<bool?>(() => null);

    /// The background color of the page.
    var backgroundColor = useComputed(() => successX.mapWithValue(_getBackgroundColor)).value;

    var smartFormController = useMemoized(() => SmartFormController());

    return Scaffold(
      appBar: AppBar(title: Text('FORMS')),
      backgroundColor: backgroundColor,
      body: SmartForm(
        controller: smartFormController,
        child: ScrollColumn.withScrollbar(
          children: [
            CategoryCard(
              category: Text('Sign Up'),
              leading: Icon(Icons.person_add),
              children: [
                Text("We don't like names that start with \"A\""),
                SmartTextField(
                  name: 'name',
                  label: 'Name',
                  validators: [
                    Validation.required(),
                  ],
                ),
                SmartTextField(
                  name: 'age',
                  label: 'Age',
                  suggestedValue: '42',
                  validators: [
                    Validation.isInteger(),
                    Validation.range(
                      minimum: 18,
                      maximum: 100,
                      onTooSmall: (_) => 'Need to be at least 18 to sign up!',
                      onTooLarge: (_) => 'How are you even that old?',
                    ).fromParsed(),
                  ],
                ),
                SmartTextField(
                  name: 'email',
                  label: 'Email',
                  validators: [
                    Validation.required(),
                    Validation.isEmail(),
                  ],
                  keyboardType: TextInputType.emailAddress,
                ),
                SmartTextField(
                  name: 'password',
                  label: 'Password',
                  validators: [Validation.isPassword()],
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SmartTextField(
                  name: 'confirmPassword',
                  label: 'Confirm Password',
                  validators: [Validation.isConfirmPassword(passwordFieldName: 'password')],
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SmartOptionsField<String?>(
                  name: 'food',
                  label: 'Favorite Food',
                  options: ['Pizza', 'Burger', 'Jalapeno'],
                  initialValue: null,
                  validators: [
                    Validation.required(),
                  ],
                ),
                SmartFormUpdateBuilder(
                  builder: (context, controller) {
                    final shouldShow = controller.getData('food') == 'Pizza';
                    if (shouldShow) {
                      return SmartOptionsField<String?>(
                        name: 'topping',
                        label: 'Favorite Topping',
                        canBeNone: true,
                        options: ['Pepperoni', 'Pineapple'],
                        initialValue: null,
                        enabled: shouldShow,
                        validators: [
                          Validation.required(),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                SmartBoolField(
                  name: 'acceptTerms',
                  child: Text('Accept the Terms and Conditions'),
                  validators: [Validation.required(onEmpty: 'Must be accepted to create an account!')],
                ),
              ],
            ),
            SmartErrorField(name: 'network'), // Show a network error if the email starts with 'a'.
            FutureButton(
              child: Text('SIGN UP'),
              onPressed: () async {
                // Wait one second just for dramatic effect.
                await Future.delayed(Duration(seconds: 1));

                var result = await smartFormController.validate();
                successX.value = result.isValid;
              },
            ),
          ],
        ),
        postValidator: (data) {
          String name = data['name'];
          if (name.toLowerCase().startsWith('a')) {
            return {'name': 'Cannot have a name that starts with "A"!'};
          }

          String email = data['email'];
          if (email.toLowerCase().startsWith('a')) {
            return {'network': 'Network error occurred.'};
          }

          return null;
        },
      ),
    );
  }

  Color _getBackgroundColor(bool? success) {
    switch (success) {
      case true:
        return Colors.green.shade200;
      case false:
        return Colors.red.shade200;
      default:
        return Color(0xffd4d4d4);
    }
  }
}
