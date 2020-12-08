import 'package:flutter/material.dart';
import 'package:jlogical_utils/smartform/fields/smart_bool_field.dart';
import 'package:jlogical_utils/smartform/fields/smart_text_field.dart';
import 'package:jlogical_utils/smartform/smart_form.dart';
import 'package:jlogical_utils/smartform/smart_form_controller.dart';
import 'package:jlogical_utils/theme/theme.dart';
import 'package:jlogical_utils/utils/popup.dart';
import 'package:jlogical_utils/widgets/category_card.dart';
import 'package:jlogical_utils/widgets/clickable_card.dart';
import 'package:jlogical_utils/widgets/menu_button.dart';
import 'package:jlogical_utils/widgets/navigation_card.dart';
import 'package:jlogical_utils/widgets/smart_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.lightTheme(
        primaryColor: Colors.blue,
        accentColor: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final SmartFormController controller = SmartFormController();

  @override
  Widget build(BuildContext context) {
    print('rebuiling home page.');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Builder(
        builder: (context) => SmartForm(
          controller: controller,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      Text('Button Bar', style: Theme.of(context).textTheme.headline4),
                      Divider(),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                            child: Text('DIALOG'),
                            onPressed: () async {
                              Popup.message(
                                context,
                                title: 'Example',
                                message: 'Here is an example popup.',
                              );
                            },
                          ),
                          OutlinedButton(
                            child: Text('SNACKBAR'),
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Snackbar!'),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {},
                                ),
                              ));
                            },
                          ),
                          MenuButton(
                            items: [
                              MenuItem(
                                text: 'Test',
                                onPressed: () {
                                  print(';hey!');
                                },
                                color: Colors.blue,
                                description: 'This is a super long description in order to test the width of a popup menu.',
                                icon: Icons.language,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 250,
                        height: 150,
                        child: ClickableCard(
                          color: Theme.of(context).primaryColor,
                          child: Center(
                            child: Text(
                              'Button 1!',
                              style: Theme.of(context).primaryTextTheme.headline4,
                            ),
                          ),
                          onTap: () {
                            print('hey!');
                          },
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        height: 150,
                        child: ClickableCard(
                          color: Theme.of(context).accentColor,
                          child: Center(
                            child: Text(
                              'Button 2!',
                              style: Theme.of(context).primaryTextTheme.headline4,
                            ),
                          ),
                          onTap: () {
                            print('hey!');
                          },
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        height: 150,
                        child: ClickableCard(
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Button 3!',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          onTap: () {
                            print('hey!');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SmartImage(
                  url: 'https://files.logoscdn.com/v1/files/7168291/content.jpg?signature=fbdfEuiCRUJOnZ4l2Al22V54Eqo',
                  width: 200,
                  height: 200,
                ),
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
                  color: Colors.orange,
                  icon: Icons.settings,
                ),
                CategoryCard(
                  category: 'General',
                  leading: Icon(
                    Icons.category,
                    color: Colors.blue,
                  ),
                  trailing: SmartBoolField(
                    name: 'bool',
                    initiallyChecked: true,
                    child: Container(),
                  ),
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
                      style: SmartBoolFieldStyle.$switch,
                      initiallyChecked: false,
                      validator: (value) async {
                        if (!value) {
                          return 'You must accept in order to continue';
                        }

                        return null;
                      },
                    ),
                    Divider(),
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
      ),
    );
  }
}
