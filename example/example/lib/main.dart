import 'package:flutter/material.dart';
import 'package:jlogical_utils/smartform/fields/smart_text_field.dart';
import 'package:jlogical_utils/smartform/smart_form.dart';

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
      appBar: AppBar(title: Text('Home')),
      body: SmartForm(
        children: [
          SmartTextField(
            name: 'name',
            label: 'Name',
            initialText: 'Jake',
          ),
          SmartTextField(
            name: 'company',
            label: 'Company',
            validator: (str) async {
              if (str.startsWith('a')) {
                return 'Can\'t start with a';
              }

              return null;
            },
          )
        ],
        onAccept: (data) {
          print(data);
        },
      ),
    );
  }
}
