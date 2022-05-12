import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

/// Page that shows off forms.
class FormPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    /// The last result of whether the port was successful or not.
    /// If [null], then the port hasn't been validated yet.
    final success = useState<bool?>(null);

    final backgroundColor = success.value.mapIfNonNull(_getBackgroundColor);

    final port = useMemoized(() => Port(
          fields: [
            StringPortField(name: 'name').required(),
            DatePortField(name: 'bornDate')
                .required()
                .isBeforeNow()
                .isBefore(DateTime.now().subtract(Duration(days: 365 * 18))),
            IntPortField(name: 'age').required().range(18, 100),
            StringPortField(name: 'email').required().isEmail(),
            StringPortField(name: 'password').required().isPassword(),
            StringPortField(name: 'confirmPassword').required().isConfirmPassword(),
            OptionsPortField<String>(
              name: 'food',
              options: ['Pizza', 'Burger', 'Jalapeno'],
              canBeNone: false,
            ),
            OptionsPortField(
              name: 'topping',
              options: ['Pepperoni', 'Pineapple'],
              canBeNone: true,
            ).validateIf((value, port) => port['food'] == 'Pizza'),
            BoolPortField(name: 'acceptTerms').required(),
            OptionsPortField(
              name: 'type',
              options: ['Payment', 'Refund'],
            ).required(),
          ],
        ).withValidator(Validator.of((port) {
          String name = port['name'];
          if (name.toLowerCase().startsWith('a')) {
            return {'name': 'Cannot have a name that starts with "A"!'};
          }

          String email = port['email'];
          if (email.toLowerCase().startsWith('a')) {
            return {'network': 'Network error occurred.'};
          }

          return null;
        })));

    return Scaffold(
      appBar: AppBar(title: Text('FORMS')),
      backgroundColor: backgroundColor,
      body: PortBuilder(
        port: port,
        child: ScrollColumn.withScrollbar(
          children: [
            CategoryCard(
              category: Text('Sign Up'),
              leading: Icon(Icons.person_add),
              children: [
                Text("We don't like names that start with \"A\""),
                StyledTextPortField(
                  name: 'name',
                  labelText: 'Name',
                ),
                StyledDatePortField(
                  name: 'bornDate',
                  labelText: 'Born',
                ),
                StyledTextPortField(
                  name: 'age',
                  labelText: 'Age',
                  suggestedValue: '42',
                ),
                StyledTextPortField(
                  name: 'email',
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                StyledTextPortField(
                  name: 'password',
                  labelText: 'Password',
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                StyledTextPortField(
                  name: 'confirmPassword',
                  labelText: 'Confirm Password',
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                StyledOptionsPortField<String?>(
                  name: 'food',
                  labelText: 'Favorite Food',
                ),
                PortUpdateBuilder(
                  builder: (port) {
                    final shouldShow = port['food'] == 'Pizza';
                    if (shouldShow) {
                      return StyledOptionsPortField<String?>(
                        name: 'topping',
                        labelText: 'Favorite Topping',
                      );
                    }
                    return Container();
                  },
                ),
                StyledCheckboxPortField(
                  name: 'acceptTerms',
                  label: Text('Accept the Terms and Conditions'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StyledRadioOptionPortField(
                      groupName: 'type',
                      radioValue: 'payment',
                      labelText: 'Payment',
                    ),
                    StyledRadioOptionPortField(
                      groupName: 'type',
                      radioValue: 'refund',
                      labelText: 'Refund',
                    ),
                  ],
                ),
                SmartErrorField(name: 'type'),
              ],
            ),
            SmartErrorField(name: 'network'), // Show a network error if the email starts with 'a'.
            FutureButton(
              child: Text('SIGN UP'),
              onPressed: () async {
                // Wait one second just for dramatic effect.
                await Future.delayed(Duration(seconds: 1));

                var result = await port.submit();
                success.value = result.isValid;
              },
            ),
          ],
        ),
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
