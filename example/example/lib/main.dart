import 'package:flutter/material.dart';
import 'package:jlogical_utils/smartform/fields/smart_bool_field.dart';
import 'package:jlogical_utils/smartform/fields/smart_text_field.dart';
import 'package:jlogical_utils/smartform/smart_form.dart';
import 'package:jlogical_utils/widgets/category_card.dart';
import 'package:jlogical_utils/widgets/navigation_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        elevation: 0,
      ),
      backgroundColor: Colors.blue,
      body: SmartForm(
        child: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              NavigationCard.url(
                title: 'Speed Test',
                description: 'Test the speed of your internet. ',
                url: 'https://www.speedtest.net',
                icon: Icons.language,
                color: Colors.purple,
              ),
              NavigationCard(
                title: 'Settings',
                description: 'Open the settings page.',
                onTap: () {
                  print('Opening');
                },
                icon: Icons.settings,
              ),
              CategoryCard(
                category: 'General',
                leading: Icon(
                  Icons.category,
                  color: Colors.blue,
                ),
                canCollapse: true,
                children: [
                  SmartTextField(
                    name: 'username',
                    label: 'Username',
                  ),
                  SmartTextField(
                    name: 'email',
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    // validator: (str) async {
                    //   var emailError = Validator.email(str, onEmpty: 'Cannot be empty!', onInvalid: 'Invalid email address.');
                    //   if (emailError != null) {
                    //     return emailError;
                    //   }
                    //
                    //   await Future.delayed(Duration(seconds: 1));
                    //   return null;
                    // },
                  ),
                  SmartTextField(
                    name: 'password',
                    label: 'Password',
                    obscureText: true,
                    // validator: (str) => Validator.password(str, onEmpty: 'Password cannot be empty!', onShortLength: 'Too short!'),
                  ),
                  SmartBoolField(
                    name: 'acceptedTerms',
                    child: Text('Accept Terms and Conditions?'),
                    initiallyChecked: false,
                    validator: (value) async {
                      if (!value) {
                        return 'You must accept in order to continue';
                      }

                      return null;
                    },
                  ),
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () async {
                      if (await controller.validate()) {
                        print('in onPressed');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        postValidator: (data) async {
          await Future.delayed(Duration(seconds: 1));
          return {
            'email': 'Email was not found in our database. ',
          };
        },
        onAccept: (data) {
          print(data);
        },
      ),
    );
  }
}
