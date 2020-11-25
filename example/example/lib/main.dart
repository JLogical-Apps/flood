import 'package:flutter/material.dart';
import 'package:jlogical_utils/smartform/fields/smart_text_field.dart';
import 'package:jlogical_utils/smartform/smart_form.dart';
import 'package:jlogical_utils/smartform/smart_form_controller.dart';
import 'package:jlogical_utils/utils/validator.dart';
import 'package:jlogical_utils/widgets/category_card.dart';

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
  final SmartFormController controller = SmartFormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Home'),
        elevation: 0,
      ),
      body: SmartForm(
        controller: controller,
        children: [
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
                validator: (str) async {
                  var emailError = Validator.email(str, onEmpty: 'Cannot be empty!', onInvalid: 'Invalid email address.');
                  if (emailError != null) {
                    return emailError;
                  }

                  await Future.delayed(Duration(seconds: 1));
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
        onAccept: (data) {
          print(data);
        },
      ),
    );
  }
}
